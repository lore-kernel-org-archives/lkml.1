Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZFPQKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZFPQKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZFPQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:10:39 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:23624 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbZFPQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:10:38 -0400
X-IronPort-AV: E=Sophos;i="4.42,229,1243814400"; 
   d="scan'208";a="176909133"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ewg@lists.openfabrics.org,
       linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [ewg] Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory operations and huge pages
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
	<adar5xoybwt.fsf@cisco.com>
	<20090616090809.34d162fc@BL3D1974.boeblingen.de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Jun 2009 09:10:39 -0700
In-Reply-To: <20090616090809.34d162fc@BL3D1974.boeblingen.de.ibm.com>
	(Alexander Schmidt's message of "Tue, 16 Jun 2009 09:08:09 +0200")
Message-ID: <adazlc8w45c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jun 2009 16:10:39.0996 (UTC) FILETIME=[FDF7E3C0:01C9EE9C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Yeah, the notifier code remains untouched as we still do not allow dynamic
 > memory operations _while_ our module is loaded. The patch allows the driver to
 > cope with DMEM operations that happened before the module was loaded, which
 > might result in a non-contiguous memory layout. When the driver registers
 > its global memory region in the system, the memory layout must be considered.
 > 
 > We chose the term "toleration" instead of "support" to illustrate this.

I see.  So things just silently broke in some cases when the driver was
loaded after operations you didn't tolerate?

Anyway, thanks for the explanation.
