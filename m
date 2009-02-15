Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZBOQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZBOQfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 11:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZBOQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 11:35:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:12287 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZBOQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 11:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kVRotHYum3f2O03+/Jvir94xEGfguTFOh3uwXfXMiAETgaOhFP3pRsvUXM9/oW7OuT
         UoBAvYaEft4POzCnNas6ONLbxl2l+DdV9X3PmvX55mCn1dJ4iW5dedMdq52VZzlrrTnm
         JzrjO2N++Fqjufqo7F94A9odZJHD3xKmdFkf0=
MIME-Version: 1.0
In-Reply-To: <20090215122956.GB7660@khazad-dum.debian.net>
References: <20090214051214.359d4fd4@leftboat.lan>
	 <20090214145256.GA7071@infradead.org>
	 <1234627163.7293.196.camel@violet>
	 <20090215122956.GB7660@khazad-dum.debian.net>
Date: Sun, 15 Feb 2009 11:35:32 -0500
Message-ID: <4ab4bbae0902150835h1158118wcb95be75d17ec37c@mail.gmail.com>
Subject: Re: [0/3] lenovo-sl-laptop : new driver for drivers/staging
From: Alexandre Rostovtsev <tetromino@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-laptop@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 7:29 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> We will be happy to review the driver in linux-acpi.  Submitting it as
> a single patch against latest Linus is probably best.

I think I found the fan speed interface; I will resubmit to linux-acpi
after I finish it.

> Oh, and it
> should be checkpatch-clean if it isn't already.

Checkpatch complains about static variables initialized to 0. Since
it's my first time writing kernel code, I have to ask what are
probably obvious questions.
1. Why is initializing a static variable to 0 bad? or worse than
initializing that variable to 1, or -1?
2. If I want to have a module parameter whose default value is 0, what
should I do to stop checkpatch from complaining?

-Alexandre
