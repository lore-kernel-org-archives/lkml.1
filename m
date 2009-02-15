Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZBOSal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZBOSal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZBOSaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:30:24 -0500
Received: from cmpxchg.org ([85.214.51.133]:47476 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZBOSaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:30:23 -0500
Date: Sun, 15 Feb 2009 19:29:49 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Rostovtsev <tetromino@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-laptop@vger.kernel.org
Subject: Re: [0/3] lenovo-sl-laptop : new driver for drivers/staging
Message-ID: <20090215182948.GA1286@cmpxchg.org>
References: <20090214051214.359d4fd4@leftboat.lan> <20090214145256.GA7071@infradead.org> <1234627163.7293.196.camel@violet> <20090215122956.GB7660@khazad-dum.debian.net> <4ab4bbae0902150835h1158118wcb95be75d17ec37c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ab4bbae0902150835h1158118wcb95be75d17ec37c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 11:35:32AM -0500, Alexandre Rostovtsev wrote:
> On Sun, Feb 15, 2009 at 7:29 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > We will be happy to review the driver in linux-acpi.  Submitting it as
> > a single patch against latest Linus is probably best.
> 
> I think I found the fan speed interface; I will resubmit to linux-acpi
> after I finish it.
> 
> > Oh, and it
> > should be checkpatch-clean if it isn't already.
> 
> Checkpatch complains about static variables initialized to 0. Since
> it's my first time writing kernel code, I have to ask what are
> probably obvious questions.
> 1. Why is initializing a static variable to 0 bad? or worse than
> initializing that variable to 1, or -1?
> 2. If I want to have a module parameter whose default value is 0, what
> should I do to stop checkpatch from complaining?

Static variables are initialized to zero automatically.

	static int foo;

is equivalent to

	static int foo = 0;
