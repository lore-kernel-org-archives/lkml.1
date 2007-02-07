Return-Path: <linux-kernel-owner+w=401wt.eu-S965460AbXBGFZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460AbXBGFZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 00:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965500AbXBGFZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 00:25:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:15222 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965460AbXBGFZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 00:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ofWyyrDkq3ydU+u7K9A0s372nsDUa+CViJgZx5t6eqkBGsnlQWqtC0mm3iXDJiSpwdUgWTdkrTntxIWYQ3Ud+sJDAxi6IDOuTSIHqVP0eHuNKtkyRDK0lYmVSrAE4BOZuukS1k3340puKlZ3HAzIHpvaLlgQqswB834SeZltV7A=
Message-ID: <1a297b360702062125p33c2f932ra61e49e4b1c9439d@mail.gmail.com>
Date: Wed, 7 Feb 2007 09:25:31 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com
In-Reply-To: <3877989d0702062019w5e57471di540404b60f7bdd43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060106x321bfb8dw918d15df76952576@mail.gmail.com>
	 <1a297b360702060129n54f73e66qc753a2ccb35cb3cd@mail.gmail.com>
	 <3877989d0702060421g1a00c114yba9e193db55f3d11@mail.gmail.com>
	 <1a297b360702060424m393d66cdka4a446b24cbd1ff@mail.gmail.com>
	 <3877989d0702062019w5e57471di540404b60f7bdd43@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Luming Yu <luming.yu@gmail.com> wrote:
> > none on the card, a flash or a firmware .. it has a 24c02 EEPROM for
> > vendor information, that's all
>
> Ok, sounds like windows driver can fix the broken EEPROM  on you card.
> Otherwise, I can not explain how windows driver can fix the problem for linux.


I have the windows driver sources for the device, it does _not_ write
anything to the EEPROM under any circumstance.

moreover the EEPROM is write protected in hardware by a jumper. So no
application can write to it, AFAICS

> Anyway, this issue is NOT linux problem. right?
>

I am not very sure about that.

really i am thinking this way .. On booting up windows, it could have
changed some BIOS stuff (written something to NVRAM or something like
that ?).. that's the only possibility that i can see here.

really lost on this one.

regards,
manu
