Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYLEDoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYLEDoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLEDoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:44:09 -0500
Received: from vps1.tull.net ([66.180.172.116]:41585 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751161AbYLEDoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:44:06 -0500
Date: Fri, 5 Dec 2008 14:44:02 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Valdis.Kletnieks@vt.edu
Cc: Geoffrey McRae <geoff@rabidhost.com>, Peter Teoh <htmldeveloper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081205034402.GB1626@mail.local.tull.net>
References: <20081203005338.6472db7a@lxorguk.ukuu.org.uk> <1228268657.6679.4.camel@lappy.spacevs.com> <20081203124252.GD11807@mail.local.tull.net> <1228344292.6993.27.camel@lappy.spacevs.com> <20081203230820.4473a162@lxorguk.ukuu.org.uk> <804dabb00812031527k3fae11dcnef3b1696c3d136f8@mail.gmail.com> <1228347656.6993.31.camel@lappy.spacevs.com> <80413.1228427770@turing-police.cc.vt.edu> <1228429854.7546.6.camel@lappy.spacevs.com> <95180.1228448127@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95180.1228448127@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 10:35:27PM -0500, Valdis.Kletnieks@vt.edu wrote:
> You're also overlooking the fact that the malicious code could do something
> like this:
> 
> 	/* send the parent something that makes it *think* the request finished */
> 	printf("We're all done now\n");
> 	while (getpid()) msleep (1);

I think it's pretty basic that setgid/setuid needs to be done _before_
exec'ing untrusted code.

On the other hand, if a trusted process gets its uid changed _and_
expects this to happen then I suppose it can be secure. But if a
process's uid gets changed unexpectedly then nasty things already
pointed out by Alan and others can occur.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
