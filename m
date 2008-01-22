Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYAVVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYAVVMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYAVVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:12:10 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:37382 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYAVVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZnRN0KRttqNgYBAnisPIBVKmF1rUkYQtxQZguURoo4GR58dZn8kQr0JT3W3uewHZFTmvGquHmtit2fhMs2Jm7TkV8QFUJ3fX228ZNeCBxN4LWH+CWsNfSUwOuxTgp3xY7JFB39Mab8lbIHPEK/u+W+KF21K+27EQatyAHpQtM7s=
Message-ID: <2c0942db0801221312v66887218qe0b9c853384ccd0b@mail.gmail.com>
Date: Tue, 22 Jan 2008 13:12:04 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Manuel Reimer" <Manuel.Spam@nurfuerspam.de>,
       "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Massive IDE problems. Who leaves data here?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fn5l9c$l6m$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fn5ivo$ck2$1@ger.gmane.org> <47965138.8060603@garzik.org>
	 <fn5jsn$ful$1@ger.gmane.org>
	 <2c0942db0801221246u678d2a20xef9cf93ee28eaf51@mail.gmail.com>
	 <fn5l9c$l6m$1@ger.gmane.org>
X-Google-Sender-Auth: c2ba7460a1b1158f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 1:04 PM, Manuel Reimer <Manuel.Spam@nurfuerspam.de> wrote:
> Ray Lee wrote:
> > (Please always do a reply-to-all for this email list.)
>
> Currently I don't have a SMTP server configured. As soon as my system is
> trustworthy, again, I'll do that.

Oy. Just know that without CC:ing people, I'm having to add Jeff back
in by hand, and we may not notice your messages. Please, with whatever
you're using to send email, CC: people that you want to read your
messages, okay? LKML gets a lot of messages, and it's easy to miss
some.

> > Bad or almost bad power supplies can cause lots of unhappy problems
> > such as these. If you have another power supply laying around, it can
> > be worth swapping them out. Double-checking that your CPU fan is still
> > spinning, and that memtest86+ doesn't show any errors doesn't hurt
> > either.
>
> ... that may be possible...
>
> I have all PCI slots filled with cards, two big IDE hard drives and one
> DVD RAM writer. I already disconnected the DVD drive, as this was nearly
> unusable with all those IDE errors. The power supply is (AFAIR) a 200
> watt one.
>
> But may the power supply cause corrupted data? Shouldn't that crash down
> the PC completely?

No, not in the least. When power supplies are on the edge and
overloaded, the quality of power drops. 12V lines may only supply 11
or less, etc. Some components in your computer will deal with it fine,
others won't.

In general, if you have weird hardware problems and you're ruled out
memory and overheating, the power supply is almost always the next
thing to check.
