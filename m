Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbYHNQ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbYHNQ35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYHNQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:29:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:24103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYHNQ3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:29:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,210,1217833200"; 
   d="scan'208";a="606798354"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] NET: e100, fix iomap read
Date: Thu, 14 Aug 2008 09:29:02 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5205DEA1D6@orsmsx418.amr.corp.intel.com>
In-Reply-To: <1218731243-32732-1-git-send-email-jirislaby@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] NET: e100, fix iomap read
Thread-Index: Acj+KqftDGvQDs/EQfiHn1j+jKBoVwAACH3A
References: <1218731243-32732-1-git-send-email-jirislaby@gmail.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Jiri Slaby" <jirislaby@gmail.com>, <jgarzik@pobox.com>
Cc: <e1000-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>
X-OriginalArrivalTime: 14 Aug 2008 16:29:19.0791 (UTC) FILETIME=[E7038BF0:01C8FE2A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> There were 2 omitted readb's used on an iomap space. eliminate them
> by using ioread8 instead.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
> Cc: John Ronciak <john.ronciak@intel.com>

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
