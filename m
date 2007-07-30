Return-Path: <linux-kernel-owner+w=401wt.eu-S969513AbXG3WL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969513AbXG3WL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969269AbXG3WKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:15096 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969235AbXG3WKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G0az7Ud/QlAZZKP6q+sCgq/ReQb++y897Z3I9sTXV4PgghaE52dMtKURuqj0fLFv30k4UziVE3kUmVX6XD3QBB0ynGenmAt0A9V7pMzX7cMfgr14Da7K35tV03bOkRJS3GhCguZ+G1z4R9EpWC0hhI/NYGjf3Prh1hTpPXjN2Mc=
Message-ID: <dcf706c60707301510n6c2b649p447396fc042c25e5@mail.gmail.com>
Date: Tue, 31 Jul 2007 00:10:35 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: forcedeth ?
Cc: "Avuton Olrich" <avuton@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46AE6029.60308@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
	 <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
	 <46AE6029.60308@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Sasa Ostrouska wrote:
> > On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
> >> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> >>> Hi people,
> >>>
> >>> I'm using this on a x86-64 amd machine. During boot of the last
> >>> 2.6.22.1 kernel I get this error:
> >> Somewhat unrelated, but I had a similar forcedeth problem, I took the
> >> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
> >>
> >> Good luck!
> >> --
> >> avuton
> >
> > Ok, maybe I can try that. In any case I noticed another strange thing.
> > I have 2 nics in that machine.
> > One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
> > RTL8029 using the
> > ne2k_pci.
> > Now, whenever I compile them both as modules each reboot the cards get
> > inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
> > the next boot it is eth1 , this is very anoying as one cant make only
> > one boot, probably this is someway related to the bios.
> > Now I configured them one in the kernel and the other as a module so
> > they get each time assigned the same name. But when powerloss happens
> > (unplug the cable) the next boot they do not work. I see them assigned
> > the correct name, ifconfig shows the IP's but ping results in a
> > destination unreachable.
> >
> > Any ideas ?
>
> Udev rules ?
>
> >
> > Rgds
> > Sasa
>
> Gabriel
>
Gabriel, hmm, shouldnt udev be able to autoconfigure that ? But I need
to check that, thx for the tip.

Rgds
Sasa
