Return-Path: <linux-kernel-owner+w=401wt.eu-S1945952AbXEAUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952AbXEAUnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945975AbXEAUnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:43:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:63185 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945976AbXEAUnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="240146226"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Ext3 vs NTFS performance
Date: Tue, 1 May 2007 13:43:18 -0700
Message-ID: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Ext3 vs NTFS performance
Thread-Index: AceMMVmfbjj7uGfMSkii7VTHJN/BEw==
From: "Cabot, Mason B" <mason.b.cabot@intel.com>
To: <linux-kernel@vger.kernel.org>
CC: "Cabot, Mason B" <mason.b.cabot@intel.com>
X-OriginalArrivalTime: 01 May 2007 20:43:08.0365 (UTC) FILETIME=[536347D0:01C78C31]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I've been testing the NAS performance of ext3/Openfiler 2.2 against
NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
video workloads. The Windows CIFS client will attempt a poor-man's
pre-allocation of the file on the server by sending 1-byte writes at
128K-byte strides, breaking block allocation on ext3 and leading to
fragmentation and poor performance. This will happen for many
applications (including iTunes) as the CIFS client issues these
pre-allocates under the application layer.

I've posted a brief paper on Intel's OSS website
(http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
it a read and let me know what you think. In particular, I'd like to
arrive at the right place to fix this problem: is it in the filesystem,
VFS, or Samba?

thanks,
Mason 

(please CC responses to mason dot b dot cabot at intel dot com)
