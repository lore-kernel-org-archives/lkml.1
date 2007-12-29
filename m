Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXL2Geg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXL2Geg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 01:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXL2Ge1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 01:34:27 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:58097 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXL2Ge1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 01:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KpByTXzPK4fZ1w/JL/zV1DrgeGJrMsxNDlp3nP7/TSi1kUZ7tMfpYTtHxS1sICVNpUOCb85esArSjpoPD7/RTYf1xnXkXiROi09x0NqIvCyh6i0GdC+i1F8C8HZLBYxu3WdlV+38Jf44dpgi7oz0SOJMawqlwoCi7KjjJS2K/rg=
Message-ID: <cabda6420712282234m41e29e34t8af2463ff4ddb5e5@mail.gmail.com>
Date: Sat, 29 Dec 2007 07:34:26 +0100
From: chri <chripell@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH RESEND] max3100 driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712290233060.29013@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11988468663187-git-send-email-chripell@gmail.com>
	 <Pine.LNX.4.64.0712290233060.29013@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 29, 2007 2:38 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> [4:128] is taken by ttyS64. Please look into Documentation/devices.txt.
>

I did it but I think it's better to reuse a minor from ttyS than
allocating a new major (64 serial ports is a lot). I saw that other
drivers take a similar approach, just tend to stay away from low
numbers that are used by 8250 and its child (that can be connected
more or less everywhere).  Perhaps in these udev times the serial
minor number should be allocated dinamicaly. Do you think this makes
sense?

>
> I notice a steep increase in serial drivers. Everyone got their
> new chips for xmas, eh? :)
>
>

This year I was a bad boy so Santa brought me just a cheap uart. For
next Xmas I hope in a WLAN chip or something like that. ;-)


-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
