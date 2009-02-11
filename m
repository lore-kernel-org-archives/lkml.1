Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZBKBvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZBKBvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZBKBvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:51:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZBKBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:51:15 -0500
Date: Tue, 10 Feb 2009 20:51:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, davej@redhat.com, sam@ravnborg.org, greg@kroah.com,
       randy.dunlap@oracle.com, kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk,
       mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org
Subject: Re: LinuxPPS core (Version 2): the PPS Linux implementation.
Message-ID: <20090211015101.GA8869@infradead.org>
References: <1234274752-29847-1-git-send-email-giometti@linux.it> <20090210155452.60ffa06b.akpm@linux-foundation.org> <499214B5.8070200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499214B5.8070200@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 03:58:45PM -0800, H. Peter Anvin wrote:
> Andrew Morton wrote:
>>
>> Is it hard to do this?  Just a matter of putting some things into
>> pps_user.h, others into pps_kernel.h and then including both into
>> pps.h?  
>>
>
> Or perhaps better...
>
> The user code in <linux/pps.h>, and then #include <linux/pps.h> from  
> <linux/pps_kernel.h>  That way we don't need any #ifdefs at all.

*nod*

that's what I had in mind.
