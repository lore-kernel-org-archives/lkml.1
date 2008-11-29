Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYK2XFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYK2XFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 18:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYK2XEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 18:04:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:64481 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYK2XEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 18:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GrNpHLIFX+MlrwGCd3lFPntP/OwOw0V9OI/HRb4xG6r99AlBgfXuRYYdGuBSrSCaqe
         GnouwZ80PqNSby1Vu44ik8daFFTUPQuvyBYKfcu37AQgGbEYEKxZCFwb6BgxjJIa25gj
         7h7mjMUPj6MiAXPZrIdFaIMDkmXZFy131O+94=
Message-ID: <45a44e480811291504l30ed8101h9ab9b5333fb33f76@mail.gmail.com>
Date: Sun, 30 Nov 2008 07:04:52 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200811291447.29932.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <492D125D.5010607@teltonika.lt>
	 <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
	 <200811291447.29932.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 6:47 AM, David Brownell <david-b@pacbell.net> wrote:
>
> In terms of low level primitives, I've already commented
> that the "read" side is missing.  An additional issue came
> to mind:  the policy of using contiguous bits should not
> be mandated here.  It doesn't need to be, either ... just
> pass a mask of valid bits, along with a mask of values.
>

Agreed. Will implement read side. I think I agree with Eric and you on
the bitmask now. It should not add much complexity, I think. I'll work
on adding it. Given that _bus() isn't appropriate anymore, how does
"gpio_set_values" and .sets sound and correspondingly gpio_get_values
and .gets?

Thanks,
jaya
