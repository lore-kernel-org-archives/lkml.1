Return-Path: <linux-kernel-owner+w=401wt.eu-S935495AbXGRRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495AbXGRRjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbXGRRjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:39:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760914AbXGRRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:39:05 -0400
Message-ID: <469E502E.8060000@zytor.com>
Date: Wed, 18 Jul 2007 10:38:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
References: <200707181342.00647.a1426z@gawab.com>	 <200707181645.01097.a1426z@gawab.com> <1184768426.4523.20.camel@daplas>	 <200707181752.29478.a1426z@gawab.com> <1184771227.4523.24.camel@daplas>
In-Reply-To: <1184771227.4523.24.camel@daplas>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> 
>> What about the VBE 3.0 arbitrary vertical refresh rate thing?
> 
> This is not implemented by the video-vesa.c because it will require
> complex calculations of mode timings (such as with GTF) to be done
> before starting the kernel.  However, uvesafb probably does.
> 

There is no real reason video-vesa.c couldn't do those calculations, but
it would have to get the information from the command line proper and
not just from the 16-bit vga= mode number.  That is a minor
complication, but not significant (the new setup code has a proper
command line parser.)

The desirability of it is another matter, especially since it wouldn't
let any switching happen at runtime.

	-hpa
