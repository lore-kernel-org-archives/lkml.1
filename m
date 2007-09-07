Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXIGQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXIGQoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbXIGQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:44:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:65371 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbXIGQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZX86EmvQi5aTskeDHqgRJAAOC6ko1OfnMLsew4Zovds6P7GsHP2xJ7WBR8r/1tuaGh8K7VGeCuRyLM4i11nKa/F8BlsMDbwvQivcnLtZti4vgAwhRkM4PdMBgCWKANutDAJJ9a++b3db/BnyOqxtvsXRtGeOW4fQApwc6BmokbM=
Message-ID: <6e7a378f0709070944l23ac5ca5te6e204e215457c59@mail.gmail.com>
Date: Fri, 7 Sep 2007 18:44:28 +0200
From: "davide rossetti" <davide.rossetti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or user-space
In-Reply-To: <6e7a378f0709060802r677b4a8emb9c8cb7530f8028b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
	 <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr>
	 <20070906133551.GA25155@nostromo.devel.redhat.com>
	 <6e7a378f0709060802r677b4a8emb9c8cb7530f8028b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm assuming you're running some sort of Fedora/RHEL/
> > derivative; this is what you get when you have a device that starts
> > out named ethX, but which needed to be renamed so that an already
> > configured ethX could be changed to that name.
>
> yes, it's FC6.
>
> > For the new device, either add a HWADDR in a ifcfg-ethX file for
> > that interface, add something to /etc/mactab, or add a udev rule.
>
> seems like HWADDR is incompatible with bonding.... there is some
> message using HWADDR as well as MASTER=bond0 and SLAVE=yes.

for the records I worked-around it:
- problem seems to be the interface 'bond0', which is started first,
stops the ability to create another device named 'eth0' (WHY?)
- so I shifted all of the interface names: 0->1, 1->2,...
now it is ok. still I do not understand why bond0 seems to interfere
with eth0...

davide
-- 
davide.rossetti@gmail.com ICQ:290677265 SKYPE:d.rossetti
