Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYJPSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYJPSa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJPSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:30:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:12990 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJPSaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tYqF1Xh35v7Sec3GiGqjhmziCMhgahCHbTbi7s0LKo4i8m6t6P6k2a5lwHGZgnT5Wq
         yMNOWVMO5W00ClVk5bW9O5k0AV8Tu7NZC1Wy3eGiZciQenTofl7xBW/5f31aQmRHKg19
         nCC1Sx1B9Hs/K1qyBfNzpKH0zmImNGbNmypcU=
Message-ID: <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
Date: Thu, 16 Oct 2008 11:30:17 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: n0ano@n0ano.com
Subject: Re: [PATCH] Enable console on PCI serial devices
Cc: "Paul Bolle" <pebolle@tiscali.nl>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20081016182556.GE14490@xolotl.n0ano.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
	 <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>
	 <20081014233031.GB14490@xolotl.n0ano.com>
	 <1224061999.25929.7.camel@test.thuisdomein>
	 <20081015204850.GC14490@xolotl.n0ano.com>
	 <1224153822.3587.23.camel@test.thuisdomein>
	 <48F76A8B.6050306@kernel.org>
	 <20081016171218.GD14490@xolotl.n0ano.com>
	 <48F785B0.7000008@kernel.org>
	 <20081016182556.GE14490@xolotl.n0ano.com>
X-Google-Sender-Auth: 47dddb86ae89f742
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:25 AM,  <n0ano@n0ano.com> wrote:
> On Thu, Oct 16, 2008 at 11:19:28AM -0700, Yinghai Lu wrote:
>>...
>>                 if ((p->early && strcmp(param, p->str) == 0) ||
>>                     (strcmp(param, "console") == 0 &&
>>                      strcmp(p->str, "earlycon") == 0)
>>...
>> we need that holder in console sections to compare with console and earlycon.
>>
>
> I have no problem with keeping the code associated with early
> prints, as you say we need that holder.  I'm saying the `console'
> parameter serves this purpose, we only need to remove the `earlycon'
> portion of that if statement.

but if someone don't need the switch from early console to normal console...

YH
