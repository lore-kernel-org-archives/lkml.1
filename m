Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbYGQC7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbYGQC7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYGQC7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:59:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:37241 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYGQC7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:59:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M6pgF8zSxqZn1ATtem9kNG8sk7zgFMhRs022wzRXnDUTj7OCWr85kNmnkVo2ZKCESg
         eLFVTrRfyyOPBCOnlO3oF5DNmzKOJdpilspz3u1uYKRB2zuf4N3k1vNBK/QrtuTaGhk2
         HKt74hO2coA61+r/m0zSJWpdkH/tHFHxSyL34=
Message-ID: <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:59:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080717023538.GA18329@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 7:35 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Yinghai,
>   As I expected pci=mmconf doesn't allow the MacBook Pro to boot.

you mean pci=nommconf doesn't work too?

2.6.25 is not using mmconf in your system.

lspci -vvxxxx could tell, if it print out 256 or 4096 pci conf space.

YH
