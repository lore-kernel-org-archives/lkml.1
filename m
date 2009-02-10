Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZBKAHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZBKAHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZBKAHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:07:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZBKAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:07:00 -0500
Message-ID: <499214B5.8070200@zytor.com>
Date: Tue, 10 Feb 2009 15:58:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, davej@redhat.com, sam@ravnborg.org, greg@kroah.com,
       randy.dunlap@oracle.com, kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk,
       mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org
Subject: Re: LinuxPPS core (Version 2): the PPS Linux implementation.
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <20090210155452.60ffa06b.akpm@linux-foundation.org>
In-Reply-To: <20090210155452.60ffa06b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Is it hard to do this?  Just a matter of putting some things into
> pps_user.h, others into pps_kernel.h and then including both into
> pps.h?  
> 

Or perhaps better...

The user code in <linux/pps.h>, and then #include <linux/pps.h> from 
<linux/pps_kernel.h>  That way we don't need any #ifdefs at all.

	-hpa
