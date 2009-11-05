Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZKESv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZKESv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbZKESv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:51:26 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51846 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbZKESvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:51:24 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOus8kqrRN+J/2dsb2JhbADJBJd1hD0E
X-IronPort-AV: E=Sophos;i="4.44,687,1249257600"; 
   d="scan'208";a="425727204"
From: Roland Dreier <rdreier@cisco.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v5] Memory DLPAR Handling
References: <4AE8ADCF.6090104@austin.ibm.com>
	<4AE8B02C.3060706@austin.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Nov 2009 10:51:27 -0800
In-Reply-To: <4AE8B02C.3060706@austin.ibm.com> (Nathan Fontenot's message of
	"Wed, 28 Oct 2009 15:57:16 -0500")
Message-ID: <adapr7wbya8.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Nov 2009 18:51:27.0923 (UTC) FILETIME=[FB3D3830:01CA5E48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't a review of this patch -- more a question out of curiousity
about how you actually can do memory remove in practice.  Do you have
any coordination between the platform/hypervisor and the kernel to make
sure that a memory region you might want to remove later gets put into
zone_movable so that there's a chance for the kernel to vacate it?  Or
do you have some other way to coordinate or at least expose which
regions of memory the kernel will have a chance at releasing?

Thanks,
  Roland
