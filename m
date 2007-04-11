Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXDKAfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXDKAfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 20:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXDKAfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 20:35:31 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20264 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXDKAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 20:35:30 -0400
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="134228824:sNHT44070192"
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
X-Message-Flag: Warning: May contain useful information
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
	<aday7kzooa7.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 10 Apr 2007 17:35:21 -0700
In-Reply-To: <aday7kzooa7.fsf@cisco.com> (Roland Dreier's message of "Tue, 10 Apr 2007 15:30:40 -0700")
Message-ID: <adahcrnoiie.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Apr 2007 00:35:21.0501 (UTC) FILETIME=[49825CD0:01C77BD1]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Is there any chance of getting a fix for the use-after-free that can
 > be caused by allocating something from userspace, failing to mmap the
 > buffer and then exiting?  To see what happens, look at how
 > ipath_create_cq sticks a struct ipath_mmap_info into the pending mmap
 > "list" (and yes it would be much cleaner to just use struct list_head
 > here rather than reimplementing a linked list yourself), and then look
 > at how ipath_destroy_cq() frees the same structure without checking if
 > it has been removed from the pending mmap list.

By the way, would it help get this fixed if I opened a bug on openfabrics.org?
Or is that a waste of time?
