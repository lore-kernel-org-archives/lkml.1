Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYEGOxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYEGOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbYEGOxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:53:35 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40151 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423AbYEGOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:53:34 -0400
Date: Wed, 7 May 2008 10:53:33 -0400
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Bart Van Assche <bart.vanassche@gmail.com>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: Compact Flash Question
Message-ID: <20080507145333.GC6957@csclub.uwaterloo.ca>
References: <48215673.3060201@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48215673.3060201@wpkg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 09:12:51AM +0200, Tomasz Chmielewski wrote:
> Compact Flash (and other similar media) does wear levelling, so 
> essentially, even if we write to the same fixed location, in reality, it 
> will mostly go to a different area on flash each time.
> 
> As Compact Flash and its wear levelling does not know about free space on 
> the filesystem, the wear levelling's effectiveness can be only limited - 
> writes won't spread on the whole free area of the flash.
> 
> Does anyone know how wear levelling is done in these devices? Perhaps it 
> will differ from a manufacturer to manufacturer, but I guess they have a 
> free area we normally use to store data, and some reserved area used just 
> for wear levelling and bad block handling, but that's just my guess.

Certainly some cards will take blocks that haven't been changed very
much and exchange them for blocks that have been written more often
(this being physical blocks, not the virtual mapping shown to the
outside).  That way the wear gets spread around more even if some parts
of the flash are never changed (from the point of view of the outside).

The actual algorithm used is vendor specific.

-- 
Len Sorensen
