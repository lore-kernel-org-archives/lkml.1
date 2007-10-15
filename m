Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbXJOLqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbXJOLqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXJOLqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:46:15 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63134 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709AbXJOLqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:46:14 -0400
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	<200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
	<1191417864.5599.2.camel@lappy>
	<200710032319.ABF69743.VJQMLHFOFOtFOS@I-love.SAKURA.ne.jp>
	<1191421736.5599.18.camel@lappy>
In-Reply-To: <1191421736.5599.18.camel@lappy>
Message-Id: <200710152046.JBJ81710.OMFQOVFOLJSHtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 15 Oct 2007 20:46:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Peter Zijlstra wrote:
> > append_function() {
> > 
> >   down(semaphore_for_write_protect);
> >   ...
> >   ptr = head;
> >   while (ptr->next) ptr = ptr->next;
> >   ptr->next = new_entry;
> >   ...
> >   up(semaphore_for_write_protect);
> > 
> > }
> 
> If at all possible, use struct mutex.

Fixed in the fourth submission ( http://lkml.org/lkml/2007/10/11/140 ).

Thank you.

