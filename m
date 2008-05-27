Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYE0RlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYE0RlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbYE0Rkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:40:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:34072 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbYE0Rkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gplQ75ZVXgh+Wi9KAAj/hmcnB0gGkYsBC2OwMF2m6PaUcQw1vYFDU4KiuNMl0YHtUhT2K0KFkh8PSsO8t3L3pWfvJdU2BQtn9ydOUbQ7kTRprDJxEsMBjlcJHIlz1GhxB1FbTpcpcVDVOVt+YuhxRl837UI5dYurtxSWJySiMTU=
Message-ID: <40f323d00805271040xcabb660obf8f0a69f9e850b5@mail.gmail.com>
Date: Tue, 27 May 2008 19:40:32 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "=?ISO-8859-1?Q?N=E9stor_Amigo_Cairo?=" <nestorac@gmail.com>
Subject: Re: QUESTION: How can I make a driver for a special serial keyboard which also supports output (maybe via serio_raw)?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       samuel.thibault@ens-lyon.org
In-Reply-To: <b321594e0805271027w4f4f003ar20ad0eb95f57721a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b321594e0805250952q18465dc2h8af60aa25143693d@mail.gmail.com>
	 <20080527084431.ZZRA012@mailhub.coreip.homeip.net>
	 <b321594e0805271025ia60c356hc19a040920587713@mail.gmail.com>
	 <b321594e0805271027w4f4f003ar20ad0eb95f57721a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please keep the cc list and reply to all]

On Tue, May 27, 2008 at 7:27 PM, Néstor Amigo Cairo <nestorac@gmail.com> wrote:
> I have been thinking on it, but it's easier to reimplement some
> widgets on Qt for just three keys (I can reuse them easily because of
> OOP), than managing focus on every widget communicating the
> application directly with the serial port (I've been using a switch
> structure for this purpose, which is not very kindly). I saw the
> device as a keyboard with just three keys and which can also receive
> some bytes from the application. This makes debugging and testing much
> easier than dealing directly with the serial interface for changing
> the focus and managing the application. The only problem is that a
> driver must be written for the device, but my long-term idea is to
> write some kind of programmable driver, so it could be reused easily
> (by instance, assigning a matrix of values to binary data sent to the
> serial port, and converting those bytes into Keys using these values,
> as in the original driver, but allowing userspace apps to change this
> behaviour). I'm not sure if it would be helpful for anyone else. And I
> also lack any knowledge of the kernel internals, as you can see.

If you just want to use it in X, then you could use ttyx (you can find
it at http://youpibouh.thefreecat.org/download/) It translates events
from the serial device to X keyboard event, it was developped by
Samuel for a similar project (a device with a couple buttons that sends
the key via a serial port).
I thinks it would be quite easy to add a table to translate to a different
key if you need that.

regards,

Benoit
