Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZJWOjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZJWOjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZJWOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:39:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35227 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZJWOjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:39:06 -0400
X-Sasl-enc: OSqw5Jypyz2G71d6ko+5srQ8Yf2BBQHGCbN84InZimM5 1256308750
Message-ID: <4AE1C00B.5010008@imap.cc>
Date: Fri, 23 Oct 2009 16:39:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
References: <4AD31213.6020006@imap.cc> <20091015114052.GA9870@ff.dom.local>	 <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>	 <20091021211906.GA11401@ami.dom.local>	 <1256160330.12174.2.camel@johannes.local>	 <20091021213947.GA12202@ami.dom.local> <1256200021.12174.11.camel@johannes.local>
In-Reply-To: <1256200021.12174.11.camel@johannes.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Johannes Berg schrieb:
> On Wed, 2009-10-21 at 23:39 +0200, Jarek Poplawski wrote:
> 
>> I'm not sure I can understand your question. This patch is mainly to
>> avoid using netif_rx()/netif_rx_ni() pair as a test of proper process
>> context handling; IMHO there're better tools for this (lockdep,
>> WARN_ON's).
> 
> I'm saying that it seems to me, as indicated by the API (and without
> proof otherwise that's how it is) the networking layer needs to have
> packets handed to it with softirqs disabled.

Strange. Then what are the two separate functions netif_rx() and
netif_rx_ni() for?

> This really should be obvious. You're fixing the warning at the source
> of the warning, rather than the source of the problem.

Good idea. So please do tell us where the source of the problem is.

Thanks,
Tilman

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFK4cALQ3+did9BuFsRAnW8AKCP4ey+gT2RZBYpzx91PaXd11A/PwCgh35g
fhEbJs++1BRIQ3encV8fIm4=
=SSaA
-----END PGP SIGNATURE-----
