Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbXFVURt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbXFVURt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbXFVURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:17:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:11622 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXFVURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tS78awpRRc1dg67HChSmDFI6dp/K0ktcLTv1BisHjBWOks9rmIbt8MwBRcubJzg8heczRdWG/wsMJ4yYT7ou45qDHeO6aCg11vaxJ93CVzNIirEMYLIGCtJRpkpnOYdTY0IxpcciDD+4vjrajqz2f86jVizn34dlcCqF3NaDqyU=
Message-ID: <a781481a0706221317q3dd49905j8773b2f8a96ad63b@mail.gmail.com>
Date: Sat, 23 Jun 2007 01:47:40 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Oliver Neukum" <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       "=?UTF-8?Q?Toralf_F=EF=BF=BDrster?=" <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706221842220.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.64.0706221602000.1817@scrub.home>
	 <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0706221735270.1817@scrub.home>
	 <Pine.LNX.4.64.0706221842220.26568@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 6/22/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jun 22 2007 18:24, Roman Zippel wrote:
> >
> >> There have been discussions to remove the default-ys again, I've sent a patch
> >> [http://lkml.org/lkml/2007/5/12/216], but nothing happened.
> >>
> >> So, should all affected menuconfigs be transformed into tristates, what
> >> do you think, Roman? Let me know so I can cook up a patch (hopefully
> >> before 2.6.22) should they become tristate.
> >
> >Using bool is clearly a bug and I'd prefer if it removed the defaults as
> >well.
>
> What I don't quite understand is, that CONFIG_CRYPTO is also a bool,
> its subparts are tristates however, and there is no problem involved
> with these.

That's because neither CONFIG_CRYPTO nor any of the crypto modules
depend on another symbol that is itself tristate (and hence can be modular),
which is the case with all the problematic cases that have been posted to
lkml lately.

Satyam
