Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYELT3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYELT3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYELT27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:28:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbYELT26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:28:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10640] audio skipping on 2.6.26-rc1
Date: Mon, 12 May 2008 21:29:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <loom.20080511T220943-718@post.gmane.org> <20080512075252.GB26074@elte.hu>
In-Reply-To: <20080512075252.GB26074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122129.15149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Ingo Molnar wrote:
> 
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
> 
> > Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10640
> > > Subject		: audio skipping on 2.6.26-rc1
> > > Submitter	: Miklos Szeredi <miklos <at> szeredi.hu>
> > > Date		: 2008-05-07 7:56 (5 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121014707707781&w=2
> > > Handled-By	: Ingo Molnar <mingo <at> elte.hu>
> > 
> > This is a duplicate of [Bug #10616] Horrendous Audio Stutter - current 
> > git .
> 
> that should be resolved via your patch which i pushed upstream (commit 
> v2.6.26-rc1-83-gaac6abc), which marks group scheduling experimental and 
> non-default.
> 
> i think the audio skipping from Miklos, if it does not go away with 
> disabling group scheduling, might also be solved by:
> 
>  - commit v2.6.26-rc1-181-g4615112 ("sched: fix weight calculations") 
>    from Mike.
> 
>  - or by commit v2.6.26-rc1-82-g3e51f33 from Peter ("sched: add optional 
>    support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK") which makes the 
>    scheduler clock more reliable [and hence produce no artificial 
>    latencies] on NOHZ
> 
>  - or by commit v2.6.26-rc1-66-ga992241 from Peter ("sched: fix 
>    normalized sleeper").

Miklos, can you please verify if the problem is present in 2.6.26-rc2?

Rafael
