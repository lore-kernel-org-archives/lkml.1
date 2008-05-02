Return-Path: <linux-kernel-owner+w=401wt.eu-S936939AbYEBWxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936939AbYEBWxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbYEBWxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:53:31 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:46171 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362AbYEBWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:53:30 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Moore\, Eric" <Eric.Moore@lsi.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: HELP: Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B3A@NAMAIL2.ad.lsil.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 15:53:28 -0700
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B3A@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 16:49:55 -0600")
Message-ID: <adawsmc2u8n.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 22:53:29.0100 (UTC) FILETIME=[5682FCC0:01C8ACA7]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Are there any 32-bit platforms with writeq()?  A quick grep 
 > > suggests not.
 > 
 > I think writeq defined in include/asm-x86/io_64.h

Umm... io_64.h is 64-bit only (look at asm-x86/io.h if you don't believe me ;)

 - R.
