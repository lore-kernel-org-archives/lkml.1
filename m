Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYGRGWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYGRGWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYGRGWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:22:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3474 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYGRGWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n52/F6TKPImYPM2MqKp77T+YwqTyoz30etMSoHLADzhiNMvtNEXpHq1PmA9BTjAnVc
         Ppt0HJ9cGJ2z7hbscRYOo6uFJn1wxxXi8NCXvRmS1qFb1Rlayh1NJs/vN3fuFb+6PKpI
         LCi96YFPkZCUiIBLZTnfjSyyUhQohY3E1qx0Y=
Message-ID: <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
Date: Thu, 17 Jul 2008 23:22:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080718060935.GA32345@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080718011532.GA30920@bromo.msbb.uc.edu>
	 <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
	 <20080718060935.GA32345@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:09 PM, Jack Howarth
<howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   I built a fedora kernel rpm using the diff of the vanilla
> 2.6.26 release vs the current git of the linus kernel tree.
> The option for pci_early_config_dump appears to have been
> renamed as earlydump. Using 'debug pci=earlydump', I get the
> following PCI information from the bios. This kernel uses your
> mmconfig patch with the dmicode of MacBookPro2.

how about
lspci -vvxxxx

YH
