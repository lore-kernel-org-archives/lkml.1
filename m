Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbYFQX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYFQX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbYFQX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:26:38 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:10189 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbYFQX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ANG6GndK/qj0olet/IKjfSwNZJXnIQSUHLfeYANQaebI7dO4RVJCefqwWM1p8rVskz
         kXL+QrAOCTFolI+O4UrOjga9di+NirGOdNs3CDmcHKEh+HF8tDfw4b2zy9I2f81beQm5
         mLQgasERMdZOfE8IMX/PansWZRsk6c8FiQXXE=
Message-ID: <72dbd3150806171626q1b8ebf54g931424b8deec5e7a@mail.gmail.com>
Date: Tue, 17 Jun 2008 16:26:36 -0700
From: "David Rees" <drees76@gmail.com>
To: mperkel@yahoo.com
Subject: Re: AMD Dual Core vs. Quad - Power Management
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <364301.54904.qm@web52506.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <364301.54904.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 3:00 PM, Marc Perkel <mperkel@yahoo.com> wrote:
> Been running a few tests and an AMD motherboard booting 2.6.25 from
> flash uses 0.33 amps if the CPU is a AM2 Athlon 6000. But if I used a
>  Phenom Quad core CPU 9550 it pulls 0.55 amps.
>
> In theory the 9550 should pull less because it's a lower TPD and the
> phenom processor is supposed to be smarter about power management.
>
> So - why is the Phenom pulling more power? Is it because power
> management software for the Phenom isn't updated yet?

At idle with CoolNQuiet on, all AMD processors seem to pull close to
the same amount of power, varying between 7-11 watts. Except for the
quad core processors, which pull significantly more at idle w/CnQ on
than dual and single core processors.

Tom's hardware has a nice chart listing power consumption here, all
his testing was done under Windows. His tests show the Phenom pulling
about twice the power of the Athlon64 X2 6000+ which matches up pretty
closely to your numbers.

http://www.tomshardware.com/reviews/amd-power-cpu,1925-7.html

Sounds like a question for AMD. The Phenoms seem to be pretty good
except for the extra 10-11w of power draw at idle which is
disappointing.

-Dave
