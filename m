Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYGRBZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYGRBZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYGRBZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:25:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:31322 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYGRBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NPdPLIkH6zkF6GFXpg+sG2/HMg02yxy+bohOmfNZlUz5xK1PsdIPGtPRn/jfstmpuI
         9ZdokVU6QHnfFJhVtbLU6Xhyiy+6K5RojwCfaQLLs1V9WE8KI799yApH0HXDzI0N7anT
         0mi6HkmmLF+Vp5zE9pRqrgO4R0xvVLpB5xb2E=
Message-ID: <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
Date: Thu, 17 Jul 2008 18:25:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080718011532.GA30920@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080718011532.GA30920@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 6:15 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   Success. It turns out that if I unset CONFIG_PCIEASPM when
> I build 2.6.26 the hangs on boot are eliminated.

good to know

> I am currently
> booted under the current fedora development 2.6.27-0.156.rc0.git4
> with that change and everything is working fine.
>   I've not had any luck with pci_early_config_dump. If I just pass
> that kernel option, it doesn't complain but it doesn't seem to
> produce any additional output in dmesg. Do I need any other kernel
> options for pci_early_config_dump to work?
shoud be pci=early_config_dump

> I will apply your mmconfig
> patch next and test how well MMCONFIG works on my MacBook Pro.

also please send out dmidecode printout, so i could update patch to
apply dmi quirk to that model only.

YH
