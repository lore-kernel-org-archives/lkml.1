Return-Path: <linux-kernel-owner+w=401wt.eu-S965245AbZLPXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245AbZLPXXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935270AbZLPXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:23:36 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52880 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935255AbZLPXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:23:34 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFb7KEurR7H+/2dsb2JhbAC+HJcKhCsE
X-IronPort-AV: E=Sophos;i="4.47,409,1257120000"; 
   d="scan'208";a="450942620"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Simon Horman <horms@verge.net.au>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec\@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	<20091216224912.GC16219@verge.net.au>
	<aday6l27c7w.fsf@roland-alpha.cisco.com> <4B296930.9020704@intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 15:23:29 -0800
In-Reply-To: <4B296930.9020704@intel.com> (Dan Williams's message of "Wed, 16
	Dec 2009 16:11:44 -0700")
Message-ID: <adatyvq7bbi.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 23:23:29.0688 (UTC) FILETIME=[C6B4A980:01CA7EA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I agree that is more robust if the init path copes with hardware
 > arriving in an unknown state.  I'll look into adding a channel reset
 > in the init path (something that should probably have been there since
 > the beginning).

Great, let me know and I'll try it on my system with kexec.

Thanks,
  Roland
