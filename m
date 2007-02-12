Return-Path: <linux-kernel-owner+w=401wt.eu-S965284AbXBLScA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965284AbXBLScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965287AbXBLSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:31:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:27760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965284AbXBLSb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:31:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mCbyjBvubj1WmLZ5JVwuLfSHbXtlq331V2Vd+sciM2VaHyXfoMrBN5OwAos/1SJe6YiXwSTbbxJRNLJTD6NXr32gEK/ecK9wBIPMzkr7SWEUl9GV63+qYUQe+WtG6TznWPQR0FSEWR8YFSkOR7TX8rZaAy3qqkhwpnmejj1vQKo=
Message-ID: <d120d5000702121031o1ea5ff20lf4e0946c8c1e2980@mail.gmail.com>
Date: Mon, 12 Feb 2007 13:31:52 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH] input: extend EV_LED
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <45CEE9AB.2020208@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45CEE9AB.2020208@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Németh Márton <nm127@freemail.hu> wrote:
>
> Extend EV_LED handling code so that it can handle not
> only two states (on/off) but also others. For example
> a LED can blink using hardware acceleration. The code
> changed so that it is similar to the code at EV_SND.
>

Hi,

I am not sure we would need this, could you explain what are you
trying to use input leds for?

Generally speaking leds within input subsystem are supposed to be very
simple on/off objects, mostly for reporting state of input devices
(keyboards), I am not even sure that LED_MAIL and LED_CHARGING make
much sense here. For more compex objects(blinking/different
colors/different brightness) we have a separate LED subsystem
(drivers/leds).

-- 
Dmitry
