Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZKSRxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZKSRxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZKSRxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:53:10 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:54807 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZKSRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=LK88IFC5gu+eP0OS/vvQO1amYi7PWX98aS8dNs/sC6gaDPEqLwup2VnDHQ2c6QvYIJ
         /2g+USX7fvKBJ0Hjlg0zyoHuca88rZ6z7GgZhua0SAZNQlDjsYEQUv/5LfcjksLcV6PT
         8XHSrhQjhBBbf4R40ceYnRx2uTdLMu5NqnH6s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 18:52:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911191838.11791.bzolnier@gmail.com> <20091119175051.6a91d160@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119175051.6a91d160@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911191852.23061.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 18:50:51 Alan Cox wrote:
> On Thu, 19 Nov 2009 18:38:11 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Thursday 19 November 2009 17:27:38 Alan Cox wrote:
> > > > > > already have a buggy cable detection (since ->pre_reset ignores the mandatory
> > > > > 
> > > > > Wrong.
> > > > 
> > > > You cannot know it unless you know how chip operates internally.  That's it.
> > > 
> > > Read the code. How the chip operates is irrelevant.
> > 
> > lol, there is a genuine cable detection bug in pata_hpt3x2n on closer look...
> 
> Oh you found it now I told you which one was buggy - well done. Already
> patched along with adding suspend/resume and fixing a performance funny.

LOL

Fixed where?  I posted the patch as soon as I noticed the problem.

Told me about it?  Now this is extra funny since the bug been there for like
three years and still would be unfixed if it wasn't for this discussion.

The best part is that the bug would never have happened in the first place
if you weren't artificially splitting HPT37x and HPT3xxN support cause cable
detection for all those chipsets (except HPT374 fn 1) is identical!! :)

-- 
Bartlomiej Zolnierkiewicz
