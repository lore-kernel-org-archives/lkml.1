Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYAASOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYAASOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 13:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYAASOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 13:14:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:62714 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYAASOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 13:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xMBzZVQ3t0gKukgbXq5F9GfOlvgpzWIaqUnW6PsK01JiVF1K4XCF2Wot5mhujCulXfFmzZ+WQO5TTIpX742Xp6Gyx/7J1FEZm9gPLS75f6322Td4kbyZU8vVKKoCJPPKlBhYMVZToJE2ECNnVx6LGT1P21FeW17TGlPw8i5upwQ=
Message-ID: <9e4733910801011014y7ae8c84ch439c56fdb1c4f303@mail.gmail.com>
Date: Tue, 1 Jan 2008 13:14:13 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080101173532.1db4019f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080101134809.GK2360@does.not.exist>
	 <20080101142344.769f16c7@the-village.bc.nu>
	 <20080101151751.GW2360@does.not.exist>
	 <20080101160708.5bb5cc2a@the-village.bc.nu>
	 <20080101163337.GX2360@does.not.exist>
	 <20080101173532.1db4019f@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/1/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > I'm not claiming that all EXPERIMENTAL tags were wrong [1], but many
> > were wrong.
>
> So why not fix the wrong tags, and mark smbfs obsolete ?
>
> > Plus the fact that CONFIG_EXPERIMENTAL controlled so many different
> > things with one switch that CONFIG_EXPERIMENTAL=n .config's are really
> > rare.
>
> Agreed

CONFIG_EXPERIMENTAL is way to coarse. I always need to turn it on and
then it loses any value.

Why not encode the drivers status into the driver name so that is is
obvious when you are configuring the kernel?

Like this for a driver name:
   Compaq Smart Array 5xxx support (experimental)

Some drivers are already do this:
   Micro Memory MM5415 Battery Backed RAM support (EXPERIMENTAL)

Now the status is obvious on an item by item basis.

-- 
Jon Smirl
jonsmirl@gmail.com
