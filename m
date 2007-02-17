Return-Path: <linux-kernel-owner+w=401wt.eu-S1946367AbXBQDEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946367AbXBQDEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 22:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946374AbXBQDEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 22:04:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:44676 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946367AbXBQDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 22:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hf4/Pgn1k/yXhlgkhGs0FHFZNdm6/m7lCWoJ36H2pBhiuHAY55k7Gh07v1O7sXslK9QphF4pnQXx91KprxiSevm1u0NZUTT3OvIUevN8AOYit/3/miFa6RN4QFAtJ87MxXCj/YKAaZUWClWL3Hc5BcauYnEAJDbAMjGexKUXxcg=
Message-ID: <d9def9db0702161904p68d72cc7ka2f2bd5c9d50e0a2@mail.gmail.com>
Date: Sat, 17 Feb 2007 04:04:52 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all modules' causes hard hang on boot
Cc: "Mike Galbraith" <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <d9def9db0702161821t737ef824p8d96ef5b3632acaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171619710.6828.24.camel@Homer.simpson.net>
	 <20070216223609.GA6165@kroah.com>
	 <1171676288.6448.9.camel@Homer.simpson.net>
	 <20070217015048.GB18591@kroah.com>
	 <d9def9db0702161821t737ef824p8d96ef5b3632acaa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 2/17/07, Greg KH <greg@kroah.com> wrote:
> > On Sat, Feb 17, 2007 at 02:38:08AM +0100, Mike Galbraith wrote:
> > > On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> > > > On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> > > > > Greetings,
> > > > >
> > > > > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> > > > > fingered the commit below, which I verified via git bisect reset;
> git
> > > > > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> > > > > boots fine.  (well, I hope I verified... i'm git-ignorant)
> > > >
> > > > If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the
> problem?
> > >
> > > It's already set.
> >
> > It's not set in the config file you sent to me and the list :)
> >
>
> I'm having a hard lockup to when I fire up xmms in X (maybe some other
> apps too) I'm bisecting at the moment.
> CONFIG_SYSFS_DEPRECIATED is set to Y here too, so I might have another
> problem here.. let's see what bisecting will show up..
>

seems to be a "wrong" alarm here, it was caused by a new xorg.conf and
an intel 855gm chipset.

Markus
