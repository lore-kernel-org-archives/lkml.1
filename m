Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYDEBG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYDEBG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYDEBGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:06:46 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:32722 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751372AbYDEBGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:06:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aUIce9Ghqji7GTs1SgJdxS3yv5EihPopLrEXXR7zqSuX3OkkmlamIiUKrkeHy+p55yIQrEzCobVQEypaX0rmFFR4sYygyiTy1MFLAFR0vjyTIy7mI+a+93JwCKtJ6Vog6GWv+wPK1dGMIh+sqImzNo4QUP5QVdFKE5pUO1W7mq8=  ;
X-YMail-OSG: LrXZ0PcVM1mWYyamRX6Mv5bB.R7JfLVcUqPSlTpELUEo.XJsQyYCP0w0OrTC2CqrEABUe1g6Tg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: GFP_ATOMIC page allocation failures.
Date: Sat, 5 Apr 2008 12:06:37 +1100
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <adYyJ-20N-11@gated-at.bofh.it> <200804042159.54220.nickpiggin@yahoo.com.au> <Pine.LNX.4.58.0804041307500.9036@be10.lrz>
In-Reply-To: <Pine.LNX.4.58.0804041307500.9036@be10.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804051206.37394.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 22:35, Bodo Eggert wrote:
> On Fri, 4 Apr 2008, Nick Piggin wrote:

> > But actually developers do sometimes want see the event even if it is
> > relatively infrequent...
>
> You shouldn't frighten the users either. /proc/sys/vm/debug?

Hence changing the message a to make it clear that it is not a
problem if it is infrequent.
