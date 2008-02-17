Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYBQTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYBQTzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYBQTz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:55:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:64400 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYBQTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:55:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=D2s4b2lRow31iDG86q+HYzo2n6gBP73Bh8f9FOVO8E9bB/T/ctlec7fJVI/JlJHBDeiCf/VN0APQTRJ6y1gay4RkB5hVUxjtxxdzcs2LIxwSpX8G3/SC911xgi5adKkS3lwKappWedHw6tQZkhCUJMkLAMdG31i1TTaJkEjXLiA=
Date: Sun, 17 Feb 2008 20:55:37 +0100
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh@vger.kernel.org, Paul Mundt <lethal@users.sourceforge.net>,
       Magnus Damm <magnus.damm@gmail.com>, matsu@igel.co.jp,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current git very broken on the Dreamcast
Message-Id: <20080217205537.db59a1f3.Kristoffer.ericson@gmail.com>
In-Reply-To: <1203191988.6737.11.camel@localhost.localdomain>
References: <1203187080.6737.3.camel@localhost.localdomain>
	<1203191304.6737.5.camel@localhost.localdomain>
	<1203191988.6737.11.camel@localhost.localdomain>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 19:59:48 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> 
> On Sat, 2008-02-16 at 19:48 +0000, Adrian McMenamin wrote:
> > On Sat, 2008-02-16 at 18:38 +0000, Adrian McMenamin wrote:
> > > Will seek to bisect this, but I have just updated my sources to the
> > > latest git and it is not booting at all on the Dreamcast.
> > > 
> 
> > adrian@bossclass:~/gdrom-dev$ git bisect good
> > e036eaa681a17f71b64f6d9040fe605555623919 is first bad commit
> > commit e036eaa681a17f71b64f6d9040fe605555623919
> > Author: Magnus Damm <magnus.damm@gmail.com>
> > Date:   Thu Feb 14 13:52:43 2008 +0900
> > 
> 
> Reverting this commit *will* let my Dreamcast boot - can it be rolled
> back pending further testing for a patch please?
> 

Just had a look at the patch. If that patch made your dreamcast not boot then you had somekind of
io_base that was used in in/out. Perhaps its better to adjust your PORT defines than work around the issue?

> Adrian
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
