Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbYFDXJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbYFDXJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYFDXJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:09:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63481 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757810AbYFDXJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:09:05 -0400
Date: Thu, 5 Jun 2008 00:08:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jon Masters <jcm@redhat.com>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <1212618462.8410.46.camel@londonpacket.bos.redhat.com>
Message-ID: <Pine.LNX.4.55.0806050005400.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>  <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de>  <m1ve0pqy06.fsf@frodo.ebiederm.org> 
 <48467DA7.9030309@suse.de>  <1212605859.8410.22.camel@londonpacket.bos.redhat.com>
  <Pine.LNX.4.55.0806042014110.28685@cliff.in.clinika.pl> 
 <1212609577.8410.32.camel@londonpacket.bos.redhat.com> 
 <Pine.LNX.4.55.0806042243080.28685@cliff.in.clinika.pl>
 <1212618462.8410.46.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Jon Masters wrote:

> *). Top level handler is *tiny*. It's job is to get called (along with
> every other such function registered for a particular IRQ line) and
> determine if its device generated the interrupt, and to acknowledge,
> preventing the device from asserting the IRQ line any longer.
> 
> The top part is called in hard IRQ context, even on RT.
> 
> *). Bottom level is automatically scheduled by the kernel in response to
> the top part acknowledging that its device caused the interrupt.
> 
> The bottom part is run inside a dedicated kernel thread.

 I see what you mean -- well, with sane hardware that should be doable 
with little effort indeed.

  Maciej
