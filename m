Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZFENjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZFENjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZFENjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:39:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48429 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZFENjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=DbLpgCVoC4NtDWE0c7hhnT8B3qkArmFDJxnrqemPwEFvmWW2u76K6NGHlGm8V2eyx+
         qySBzRRNnTPUCEQLcpZjMT7Kmwq04XVyaiKpuDJLGOpdhP6zqR52uRZuzTqRvYAl8Qp7
         WQJEN5n4F1uQ/CCcTEKg8yAbyuV8ohBWrh21s=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
Date: Fri, 5 Jun 2009 14:39:09 +0100
Message-ID: <9b2b86520906050639x2ceb42b5r5c454a024c5e10aa@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/09, Corentin Chary <corentin.chary@gmail.com> wrote:
> On Fri, Jun 5, 2009 at 2:44 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>> Hi Corentin,
>>
>> On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
>>> First, I think a one line
>>> set_acpi(CM_ASL_CAMERA, 1);
>>> with a small comment is better. (If it fails, it's because there no
>>> camera, so we don't mind).
>>
>> OK, I've included an updated version of the patch.
>>
>> On Fri, 2009-06-05 at 13:46 +0200, Corentin Chary wrote:
>>> Anyway, I'm not sure it's a good idea to enable the camera by default.
>>> It depends how many power the camera is using (when idle). Coud you
>>> check that (with power top maybe ?).
>>
>> People who prefer power savings over functional camera can always
>> disable it. If you look at the amount of "my camera doesn't" work bug
>> reports, I think it's pretty evident that we should enable it by default
>> or provide a config option that does it.
>
> Ok, your right, I'll apply that one
>
>> That said, I am more than happy to measure this but I need a little bit
>> more information to get started as I have never used powertop. So what
>> is it exactly you want me to do?
>
> PowerTop (with a corretly configured kernel) will give you a power
> usage estimate.
>
> CONFIG_NO_HZ=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_KERNEL=y
>
> For propers results, shutdown all services and just keep a shell
> (without X or network).
> You can also test that with and without the camera driver.

Hmm, this relies on good acpi battery information, I hope your EeePC
is better than mine in that regard.

The ideal solution is if USB auto-suspend could be used to save the
same amount.  Google says there was a patch for uvcvideo last year
[1].  I'll see what the current status is on my model and report back
:-).

[1] <http://lists.berlios.de/pipermail/linux-uvc-devel/2008-January/002707.html>

Alan
