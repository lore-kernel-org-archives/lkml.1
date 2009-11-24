Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZKXGRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZKXGRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZKXGRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:17:05 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62526 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZKXGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZnfXJUzO9sjaDsO5UlzZXPohg76FOxTIziMgYrBJYabS8zwJyhT1HUjHFLzlsGRKJr
         +1TUEMXdWx71yPLfFW7rn4wKyPoKgR/AlLwnPXfyz1YhfYRtJvY5hwFXASIidh231+5g
         Ls1aWdjkIHzZnF2lF6XEoJPDs1lBhqKlG13oE=
MIME-Version: 1.0
In-Reply-To: <20091122205054.GA7361@ami.dom.local>
References: <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
	 <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
	 <20091113211640.GA2540@ami.dom.local>
	 <81bfc67a0911180159g45a45675k44ce3f251c6bddea@mail.gmail.com>
	 <20091118135136.GA9224@ff.dom.local>
	 <81bfc67a0911181021n1b969565y4a39b181360b5e92@mail.gmail.com>
	 <20091118201034.GA3060@ami.dom.local>
	 <20091118223851.GA5191@ami.dom.local>
	 <81bfc67a0911221135y300841f2i8e78417600528cd5@mail.gmail.com>
	 <20091122205054.GA7361@ami.dom.local>
Date: Tue, 24 Nov 2009 01:17:09 -0500
Message-ID: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, currently I don't consider this dropping means there has to be
> a bug. It could be otherwise - a feature... e.g. when a new kernel
> can transmit faster (then dropping in some other, slower place can
> happen).

um... where would it be dropping that we wouldn't have a bug? I mean
sure faster is great... but if it makes my network not work right...

I've added all (I think) information you've asked for to the bug
http://bugzilla.kernel.org/show_bug.cgi?id=13835 except for ethtool
and netstat on the router side. ethtool complains about not having
driver or capability (maybe because it's a 2.4 kernel?) and the
version of netstat doesn't support -s. I disabled everything that I
can think of that would send/receive packets before doing the test
client side, except dhcp/dns windows box's were probably sending some
broadcasts too. but the traffic should be pretty low. I did remember
to set the txqueuelen didn't seem to make a difference

only error in dmesg I see is

e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb

but it's in working versions too.
-- 
Caleb Cushing

http://xenoterracide.blogspot.com
