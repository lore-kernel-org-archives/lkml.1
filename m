Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYACQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYACQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYACQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:21:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:51658 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYACQV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fRpqHqg2tRf4jJPTSfF2Mnh4eJqsSYEbRDKvCsonkkcTVKz4poKoL3TCQ87azbtij4EkkcWB0Afe3hnYcPsUIY7kRG6W45XTsl1BBXfrCJ3/4QH7J6MQKta6721Bf27VcsTRTzzQb6L3U5k+T6kpc11LdkuO1MuMx/o40ZJZwMw=
Message-ID: <d120d5000801030821h21996040s1e1743ac8ceb2370@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:21:55 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?R=E9mi_H=E9rilier?=" <rherilier@yahoo.fr>
Subject: Re: PATCH] adding wistron_btns support for X86_64 systems.
Cc: "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <477C10AD.7060303@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200712222040.14422.carlos@strangeworlds.co.uk>
	 <477C10AD.7060303@yahoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rémi,

On Jan 2, 2008 5:31 PM, Rémi Hérilier <rherilier@yahoo.fr> wrote:
> Carlos Corbacho wrote:
> > (CC'ing linux-input, as that is the relevant subsystem list for wistron-btns).
> >
> > Rémi Hérilier wrote:
> >> To use my previous patch (wistron_btns support for fujitsu-siemens amilo
> >> pro edition v3505) with my laptop, I need to make the wistron module
> >> compile for x86_64. It is based on Linux 2.4.24-rc4 too.
> >
> > NAK.
> >
> > You cannot make 32 bit BIOS calls in a 64 bit OS.
> >
> > This will (and does) segfault on x86-64 (tested on my Aspire 5020, where
> > call_bios wistron-btns just segfaults on x86-64 with this patch).
> >
> > This is a known issue, and the reason why wistron-btns (and the out-of-tree
> > acerhk) have not been ported to x86-64.
> >
> > -Carlos
>
> Yes, in theory, this must segfault on x86-64.
>
> In pratice, there is one laptop where it seems to works (no problem
> for 3 weeks). A good reason to find why.
>

My concern that even on that particular model this may stop wotking if
you upgrade BIOS. Otherwise the fact that it doe snot work on some
other laptop should not stop us - we using DMI matching in wistron
buttons anyway.

-- 
Dmitry
