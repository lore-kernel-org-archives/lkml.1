Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZH1Vs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZH1Vs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZH1Vs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:48:59 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:35970 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZH1Vs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mitb2xlNsWrfuKJQ+3Ly9VHp+DCdYdKAA6lyZWuO+5UNsbwe5LoqnV6OdIqdu6Gwzx
         fL+oTDkk1p5NpgnfQfm17KDGMyLrKq1C+CdkuBgD4R0HoTqfwm0zeDPhwrpIWGQ+fb8V
         OcN13jqlM2s22jAc0I1OrS4uA2n/8KwukC/VQ=
MIME-Version: 1.0
In-Reply-To: <20090712080410.GA8512@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com> 
	<20090712080410.GA8512@localhost>
From: Fernando Silveira <fsilveira@gmail.com>
Date: Fri, 28 Aug 2009 18:48:40 -0300
Message-ID: <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com>
Subject: Re: I/O and pdflush
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 05:04, Wu Fengguang<fengguang.wu@intel.com> wrote:
> On Sat, Jul 11, 2009 at 02:27:25PM -0300, Fernando Silveira wrote:
>> I'm having a hard time with an application that writes sequentially
>> 250GB of non-stop data directly to a solid state disk (OCZ SSD CORE
>> v2) device and I hope you can help me. The command "dd if=/dev/zero
>> of=/dev/sdc bs=4M" reproduces the same symptoms I'm having and writes
>> exactly as that application does.
>
> What's your kernel version?  Can the following patch help?

Sorry for the delay, but I could not test it before.

Unfortunately it did not help or change any symptoms at all. The
kernel version I tested was a non-patched 2.6.30.1 version.

Do you have any other hint?

-- 
Fernando Silveira <fsilveira@gmail.com>
