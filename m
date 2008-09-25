Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYIYWXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYIYWXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYIYWWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:22:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7426 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYIYWWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gYP3UZoCyhUyhQdIQpaQnTeROM6vSBOX84XUWk+NHWFeEU65jNwsFf03Rql1nHhpAs
         R1L9N31wP/5vnS9Ws/RRLEJ72bb9K2s9psfb4SswVhUdX29egK77rq4IVoMaQNqr2wlR
         sv6JNew/3jKeqaN4PQ4HMa28RSP0H3MqDEFnM=
Message-ID: <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>
Date: Thu, 25 Sep 2008 18:22:50 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080925220454.GA12116@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de>
	 <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
	 <20080925020608.GA13869@suse.de>
	 <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	 <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
	 <20080925220454.GA12116@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 6:04 PM, Greg KH <gregkh@suse.de> wrote:
>
> What's the objection for the 9 extra lines in module.c, 2 lines in
> panic.c, and 9 lines on scripts/mod/modpost.c?  Is this some huge
> overhead that is unmaintainable?

You don't tell me why you want to do something as absurd and
incoherent as wanting users to load the modules easily and
automatically, then printing a warning about it even when user may not
have loaded it on his/her own, then taint the kernel when there is no
need to - I have repeatedly said it is very easy to see from the
module list for people to decide - not rocket science, definitely not
for developers. The whole TAINT drama is unnecessary.

Why would people run with even 24 more lines for something as absurd
as this when there is no need for the same?

Sure if you want to autoload modules on users back - do not complain
about it, do not make it official that it won't be supported since if
you do all your staging drivers are even more likely to stay there
like EXPERIMENTAL. (i.e. take out the printk , take out the TAINT) -
then it sounds less absurd.

Parag
