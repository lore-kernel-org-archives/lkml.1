Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYKSI6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYKSI6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKSI6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:58:36 -0500
Received: from smtp.net4india.com ([202.71.148.84]:43729 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYKSI6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:58:35 -0500
X-Greylist: delayed 54030 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2008 03:58:35 EST
Subject: Re: Developing non-commercial drivers ?
From: Radhakrishnan <rk@atr-labs.com>
Reply-To: rk@atr-labs.com
To: Chris Friesen <cfriesen@nortel.com>
Cc: Fredrik =?ISO-8859-1?Q?Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <4922F8C4.80509@nortel.com>
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
	 <4922ED5A.3030808@shaw.ca>
	 <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
	 <4922F8C4.80509@nortel.com>
Content-Type: text/plain; charset=utf-8
Organization: ATR LABS
Date: Tue, 18 Nov 2008 23:30:53 +0530
Message-Id: <1227031253.1817.20.camel@win2k.atr-labs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an interesting situation that seemingly meets the GPL clause
but is also used for developing proprietory drivers, and it works as
under :

Consider an organization A ( the Technical organization ) that is
contracted with developing specific hardware & software for an
organization B that happens to be the Navy.

Also assume that both the organizations ( A & B ) are under the Ministry
of Defence.

Organization A now contracts me, a freelancer, for developing some linux
kernel drivers for an embedded defence related project.

I develop the drivers and hand them over to Organization A and clearly
mark my code as GPL since I believe in the spirit of GPL.

However, Organization A now bundles the code with the specially
'manufactured' hardware and sells it to their ONLY customer,
Organization B ( The Navy ).

Now, Organization B ( The Navy ) who is also the CUSTOMER, INSISTS that
Organization A NOT REVEAL the source code to anybody else and this is
agreed upon by Organization A since the software can ONLY work on the
specific hardware supplied to the Navy and this is a highly classified
project, and cannot/will not be sold to anyone else.

Under this scenario,

a) The software is GPL-ed

b) No-one can get to see the software unless I the developer squeal.
A 3rd party cannot pop-up and demand to see the software since the 3rd
party is not a customer or in any way related to any transaction.

c) If I squeal, I may disappear. Since I am paid for my hard work lets
say I do not have any desire to squeal.

Am I therefore right in assuming that this is a specific case where the
open source nature of Linux is being used with great effect but the very
nature of the licensing denies ANYONE ELSE from being a party to this
transaction ?

V. Radhakrishnan
www.atr-labs.com


On Tue, 2008-11-18 at 11:17 -0600, Chris Friesen wrote:
> Fredrik Markström wrote:
> 
> > At this point I feel that we have two possibilities, help our customer
> > violate GPL or say no to the project. I'd prefer a third option where
> > I could tell the customer that we can setup the project in a certain
> > way (some "cleanroom" setup ?) to ensure that the results can not be
> > considered derived work.
> > 
> > Is your short answer also the definite answer considering this ?
> 
> I'm not a lawyer, and you need to consult one.
> 
> There isn't really a "definate answer" since it depends on copyright 
> law, which varies by region.  The key question is whether the driver is 
> a derivative work of the kernel under copyright law.  For the purposes 
> of copyright law this is primarily a legal question, not a technical one.
> 
> There are some that claim that a driver written for another OS and 
> running in linux via a shim layer could qualify (especially if the 
> closed-source portion is written without any knowledge of linux 
> internals).  Nvidia is one company that does this, but there are others 
> as well.
> 
> Also, releasing the driver under the GPL doesn't necessarily mean 
> "released to the world".  Technically, they would only need to provide 
> source code to their customers.  Of course, their customers would be 
> free to redistribute, but it's unlikely that most of them would bother.
> 
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

