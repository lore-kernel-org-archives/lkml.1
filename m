Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbYEBLp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbYEBLp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbYEBLpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:45:20 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:23612 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760249AbYEBLpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:45:19 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Horrendous Audio Stutter - current git
Date: Fri, 2 May 2008 13:45:16 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <200805021337.10809.elendil@planet.nl> <1209728372.13978.147.camel@twins>
In-Reply-To: <1209728372.13978.147.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021345.17179.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 11:45:17.0831 (UTC) FILETIME=[FE40D170:01C8AC49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Peter Zijlstra wrote:
> On Fri, 2008-05-02 at 13:37 +0200, Frans Pop wrote:
> > On Friday 02 May 2008, Peter Zijlstra wrote:
> > > > Ok, that's _WAY_ too big, something went seriously wrong. Thanks!
> > >
> > > In fact, that is exactly 1024 time too large.
> > >
> > > How does this work for you:
> >
> > Changes nothing. Values of bonus_max are unchanged and still skips.
>
> Humm, I saw some bonus_max spikes on my laptop which were fixed by that
> patchlet, ah well, the hunt goes on.

Oh! Hang on. I just checked and saw that I made the change in 
dequeue_entity() instead of enqueue_entity(). Let me try again.

For code symmetry I guess both should probably be changed?

Sorry for the mistake.
