Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYG3Tq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYG3Tq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbYG3TqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:46:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:4137 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYG3TqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=H0qFUSvjtxFCmHu02FSLKtw8Uc8Vl28oOmJRzQ1YPmFqfhUE4ubrvnL2J9EvdeyUuk
         5G4i7fFAHEZnBvs0Baqr9o3nm75oXaYNnC4JNZBOiSMZFNjy2cgwAG3XwXcKnk+IHMVV
         q2pRWcPXcQDtiuYOTyaTHTOkda19ItNqYm9Ak=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: usb tree fix (Was: Re: linux-next: Tree for July 29)
Date: Wed, 30 Jul 2008 21:38:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <haveblue@us.ibm.com>, Greg KH <gregkh@suse.de>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au> <200807291825.14281.bzolnier@gmail.com> <20080730110554.9bea652b.sfr@canb.auug.org.au>
In-Reply-To: <20080730110554.9bea652b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807302138.47972.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, Stephen Rothwell wrote:
> Hi Bart,
> 
> On Tue, 29 Jul 2008 18:25:14 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > I keep reverting commit 0e3638d1e04040121af00195f7e4628078246489 ("warn
> > when statically-allocated kobjects are used") with each linux-next release
> > to make it work on my x86_32 laptop (http://lkml.org/lkml/2008/7/19/114).
> > 
> > Depending on the day I either forget to revert it on a first try or (lead by
> > incurable optimism) I don't try to revert it in hope that it was fixed.
> > 
> > Unfortunately the result is always the same cursing-during-qemu-test-run
> > -> git-revert -> recompile cycle and a needless time loss.
> > 
> > Could we have some action taken please?
> 
> I have reverted that commit from linux-next today (its id has changed)
> and will do so until Greg or Dave tells me it has been fixed.  To make
> life easier for me, Greg, it would be nice if you removed it from your
> series until that time.

Thanks but since now there is a fix (even two!) for the issue and Dave's
patch has the value of catching real bugs maybe we could have one of the
fixes in linux-next instead of revert?

PS ironically today's linux-next broke xorg for me... call me lucky...

Bart
