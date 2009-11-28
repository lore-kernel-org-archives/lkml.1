Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbZK1H33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbZK1H33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 02:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZK1H32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 02:29:28 -0500
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:28973 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751782AbZK1H32 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 02:29:28 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 02:29:27 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pQKjK5jod8ntsicft9lb+yaj3/MwB5ddYMnkFG8uJ3aPrqy9gK9IFI+85mOuQaQKeaZ92xf8lJgs2yMTLfpab39VF6WrRH3iyR+T4lVCQN6k2G9GIL4+CSAAI/wiuW/dHix7Ig/CgJMiNgpNSASIJsSDjmFxzcdcOxnCsDuL4Kk=;
Message-ID: <716701.11435.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: nJTVqhQVM1mkcoCJAKhnLwQGbBqQzCbJqtWXMBbsQV1GyoDc8fkzjw4HQMVkYSYpUNolhn5Krsq8W._n_AaovTJ8zBdaFOPi0FAooBaC25j.H3U2l9xCXrcvh3ik7ISpH1eI5Rouomoz5nqSB4SjCtHLgaGoAz6DwzLHAMn2uOgCxuecsj9mPoH6BP6_bERPmkNjJaNo5ylIhKqzCeHNY4VMnppQ.RV8wG6BNA3wh.KTRbCpUvuhExQxypG05uAbstJkprWIvitbm5rYdO5R4rOVk3IPMurpGjtTM4phqdMhSpz66BowR6gzv.6K5t6NOznpmouzElkoa.j4xR2NS4TCx3rz_ra06w98TilHHkubJz6OwHq7epXrsRIcv7w5KfXjQcVn9otw5VvEztSyfxxUzyzKgcR325FwQWFMAKvE136fer1Z79fz127zHr0tWTYXjgZPGaenJw7WmorK2kNVdyGkUhbC3N2Y4cwg6tqCDmgjuicUkO0gTDzx
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Fri, 27 Nov 2009 23:22:53 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: XD/smartmedia - how to implement it right?
To: Maxim Levitsky <slevmax@t2.technion.ac.il>,
       =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
In-Reply-To: <20091121102542.GA21136@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The "mtd uses blocking calls" argument I can help
> with.  For some other
> project I've added non-blocking calls to mtd[1].
> 
> Biggest problems I see are a) the userspace interface and
> b) allowing
> both raw flash access through MTD and block device access
> with an FTL.
> 
> [1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html
> 
> Jörn

I actually tried several approaches to this problem and I think, I have a good idea about how to create a fully asynchronous mtd driver, which can handle different device models. Unfortunately, I had other commitments so I couldn't advance my mtd stuff.

Recently I was going to go back to it, but then I was asked to implement some additional functionality in rapidio subsystem, which I'll have to take care of first.



      
