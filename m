Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZFYAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZFYAU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZFYAUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:20:20 -0400
Received: from fifo99.com ([67.223.236.141]:59072 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFYAUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:20:19 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com, Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <63386a3d0906241701o720fa667t662b9e3d4f080397@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <1245254936.5982.261.camel@desktop> <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	 <63386a3d0906241701o720fa667t662b9e3d4f080397@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 17:20:19 -0700
Message-Id: <1245889219.32124.280.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 02:01 +0200, Linus Walleij wrote:

> What I really want to know, is how this relates to the vmsplice() and
> other zero-copy buffer passing schemes already in the kernel. I was
> sort of dreaming that D-Bus and other IPC could be accelerated on
> top of that.

Marcel had mentioned earlier in this thread that D-Bus could be
accelerated with shared memory or moving the dbus-daemon into the
kernel. splice() and vmplice() seem like fairly robust system calls. I
would think they could be used also ..

Daniel

