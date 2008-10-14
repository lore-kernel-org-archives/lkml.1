Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYJNNah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYJNNah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYJNNa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:30:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYJNNa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:30:29 -0400
Date: Tue, 14 Oct 2008 10:28:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix Numlock led on two keyboards (Dell SK8115 and
 Bright)
Message-ID: <20081014102815.632b9cf6@pedra.chehab.org>
In-Reply-To: <alpine.LNX.1.10.0810131747260.26779@jikos.suse.cz>
References: <20081009170544.4e770dbb@pedra.chehab.org>
	<alpine.LNX.1.10.0810131747260.26779@jikos.suse.cz>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 13 Oct 2008 17:49:52 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> > The keyboards are:
> > DELL SK8115 (USB ID 413c:2105); and
> > Bright keyboard (USB ID 1241:1503).

> the HID subsystem went through a refactoring, and all the quirks have been 
> separated into individual drivers, so that the code doens't become 
> unmaintainable mess by having quirks all over the place.
> 
> The changes have been present in my git tree -next for quite some time, 
> and I am planning to send a push request to Linus probably tomorrow. Do 
> you think you could rebase your patch on top of my tree?
> 
> For Dell changes this should be trivial, as there is already a driver 
> handling exactly this for other Dell keyboards.

Ok, I've rebased the patches, from 'next-20080919' tag, at -next. I'll be
sending you the patches on the next emails.

In the case of the Bright keyboard, I've cloned Dell entry, since the problem
is similar.

-- 

Cheers,
Mauro
