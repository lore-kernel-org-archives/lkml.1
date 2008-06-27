Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYF0OPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYF0OPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYF0OPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:15:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:25627 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYF0OPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cBqmbYh/wWRT5tomWS5grpeqUeEEBno/K+iNtYhE+qDQMEjW0GU3V2QdQze5qEkyaG
         3wTWzKjUVoDS52g1Kr2dWIAfEFxX1GuphGqRv2gNtUuYWqkuhBXell1+qhl9CepcygSq
         S29Iq9cr4ROWpLhSP1HDFEA9akl8WLDaZHugY=
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
From: Josh Boyer <jwboyer@gmail.com>
To: Tomas M <tomas@slax.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, Pavel Machek <pavel@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4864F524.2070603@slax.org>
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz>
	 <alpine.LNX.1.10.0806271532150.12725@fbirervta.pbzchgretzou.qr>
	 <4864F524.2070603@slax.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 10:15:39 -0400
Message-Id: <1214576139.7698.13.camel@weaponx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 16:11 +0200, Tomas M wrote:
> Jan Engelhardt wrote:
> > On Thursday 2008-06-26 22:17, Pavel Machek wrote:
> >>> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)
> >> You need some good reason why lzma should be in kernel... like 'cramfs
> >> can use it'...?
> > 
> > squashfs if at all.
> > 
> 
> Well anything can use lzma or any other compressions, not only squashfs.
> Squashfs is a great example, where you get 30% smaller filesystems compared to gzip.

JFFS2 has an framework for having multiple compression algorithms.
Adding LZMA to that wouldn't be difficult either.

josh

