Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYGVB7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYGVB7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 21:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYGVB6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 21:58:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:52693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYGVB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 21:58:52 -0400
Subject: Re: Status of the radeonfb driver?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b637ec0b0807211135u19659393x56605e936a0dce7d@mail.gmail.com>
References: <b637ec0b0807211135u19659393x56605e936a0dce7d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 11:58:46 +1000
Message-Id: <1216691926.11027.174.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 20:35 +0200, Fabio Comolli wrote:
> Hi.
> 
> The subject says it all, I think. I'm asking because my quite old
> Radeon Mobility X700 ( 1002:5653) is still not supported in latest
> Linus' GIT tree.
> There were some patching floating around some months ago but they
> lacked suspend/resume support. Are there any progress or patches to
> test ?

Not really. I'm waiting for the long overdue (unfortunately) support
for mode setting in the DRM to obsolete radeonfb and finally get rid of
it ...

As far as I'm concerned, it's on life support mode... I make sure it
still works for stuff it supports today but I'm not actively developing
support for new stuff.

I'm not sure where the X700/800 support patches went tho... I suppose
they could be merged at one point.

Ben.


