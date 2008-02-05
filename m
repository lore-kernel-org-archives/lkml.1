Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYBEIQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYBEIQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYBEIQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:16:33 -0500
Received: from smtp-in.kfki.hu ([148.6.0.26]:54458 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbYBEIQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:16:32 -0500
Date: Tue, 5 Feb 2008 09:16:29 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Patrick McHardy <kaber@trash.net>, lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: cups slow on linux-2.6.24
In-Reply-To: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.0802050909220.32232@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Jeff Chua wrote:

> On Feb 5, 2008 4:17 AM, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> 
> > Actively closed connections are not handled properly, i.e. the initiator of
> > the active close should not be taken into account. So could you give a try
> > to the patch below? Does it just suppress the 'invalid packed ignored' and
> > all other kernel messages or both suppresses them and produces normal
> > printing speed?
> 
> Amazing! You fixed it. No more 'invalid packed ignored', and speed back to
> normal (continues after approx. 20 seconds of pausing after 503 prints).

Great! Thank you for the testing!
 
> I used the latest git, and have to modify your patch slightly to make it work
> (changing "conntrack" to "ct").

Patrick, I suppose you need a patch against the latest git, don't you?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
