Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXIOVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXIOVT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 17:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXIOVTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 17:19:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXIOVTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 17:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rsdwk+n2fwU/509L5w8zYVyTJoZcDnqrmIBz+CaivnZMBG2/G4HaRSQZFJhbDe/nnO3iXDIc/twmQ98vVlZKMFn+1eB2oX9mt5rksb1QSTTJivVSyyJv5HWeq99zT5x1waKsM38L6guEhxQIPxn1D6UdI1+yxLis1lp1hMHsx5g=
Message-ID: <6b8cef970709151419r7561e950jcc35f4a50661273f@mail.gmail.com>
Date: Sat, 15 Sep 2007 17:19:17 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "=?ISO-2022-JP?B?GyRCJV0hPCVrISYlbSVpJXMbKEIgUGF1bCBSb2xsYW5k?=" 
	<rol@witbe.net>
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as a module. Works as a module.
Cc: eric.valette@free.fr, flamingice@sourmilk.net, andreamrl@tiscali.it,
       linux-kernel@vger.kernel.org,
       "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20070915185153.08490a9b@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EBE70C.2040201@free.fr> <46EBEBD2.7060502@free.fr>
	 <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
	 <46EC24B6.2030709@free.fr> <20070915185153.08490a9b@tux.DEF.witbe.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, ポール・ロラン Paul Rolland <rol@witbe.net> wrote:
> Hi Eric,
>
> On Sat, 15 Sep 2007 20:30:14 +0200
> Eric Valette <eric.valette@free.fr> wrote:
>
> > Rob Hussey wrote:
> > > On 9/15/07, Eric Valette <eric.valette@free.fr> wrote:
> > >> Eric Valette wrote:
> > >>
> >
> > Thanks for your help: it does indeed fix the problem.
> Nice it works for you too !
>
> > Now I have two side questions:
> >       - the code is no more symetric "subsys_initcall" -> "module_exit".
> > Do not know if it is "normal" but I love symmetry in code :-). Did not test
> > it still works as a module...
> Symmetry is not broken, as we have :
> #define subsys_initcall(fn)             module_init(fn)
> in include/linux/init.h where compiling as a module, and when not compiling
> as a module, I doubt the exit function is called unless you are shuting
> down your machine...
>
> >       - Who takes the responsability to push a patch to Linus? I guess it
> > is urgent unless he plans a rc7
> Good point ! I expect the patches to be already in some queue waiting to be
> pulled !

The patches are on their way to making it into 2.6.23:
http://marc.info/?l=linux-netdev&m=118986368303529&w=2

Regards,
Rob
