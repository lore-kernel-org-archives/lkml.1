Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbYGRQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbYGRQT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbYGRQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:19:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:48383 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbYGRQTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZtGgRHUuaoPwcTj8CyPuyt6NI2ewJdJgQ1vRgWV+/gVVui1K0YcmavJzYyp2UTECzc
         N2M2oirIZdnWlz7xqQoNn5AoPs83T675BotR8IiIco2ng+b0QRPITReNlFb+J5jtKlvT
         nN/B8qDApz46EXbea1ThgWQCKLqHfnTGzg24U=
Message-ID: <86802c440807180919id6220ecqe0a25b2a94dc39c0@mail.gmail.com>
Date: Fri, 18 Jul 2008 09:19:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080718120930.GA2916@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080718011532.GA30920@bromo.msbb.uc.edu>
	 <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
	 <20080718060935.GA32345@bromo.msbb.uc.edu>
	 <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
	 <20080718120930.GA2916@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 5:09 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   Do you see anything in the pci earlydump and the associated lspci --vvxxxx
> output that sheds any light on why we have to clean up the dmi with your
> mmconfig patch on a MacBookPro2? I am wondering if the BIOS information is
> being misused by the linux kernel or if the BIOS is just buggy.

BIOS is buggy. it said it need 0-255, but only reserve address range
for 64 buses

will resend patch to Ingo and Jesse,

YH
