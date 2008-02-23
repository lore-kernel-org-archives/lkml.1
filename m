Return-Path: <linux-kernel-owner+w=401wt.eu-S937778AbYBWAzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937778AbYBWAzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937245AbYBWAvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:51:39 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:36581 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937094AbYBWAvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:51:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nKJ55wPoBodZ1P+QOwSRIexzP2GMw1L0fLXCC1YMvkk5LQZDpVe5TakR02A2ifgzsyNshnVnnAgirHVsQBMlYQZ+TiEZA4Bbuh+x4U3mejzOIW/Biky828lVZXXNsokPidTcO6C/8LMBrv+Uj/VZspRAJFuz0UGmLgPToUKsWuk=  ;
X-YMail-OSG: C5_2qWsVM1lwZvGXMh0WrMf9nujQtaEZXVRIW1s9YBXW2qe4GCQEREWMprJnTINNVqX.xury0w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Fri, 22 Feb 2008 16:51:30 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200710181551.24912.florian.fainelli@telecomint.eu> <200802131755.30921.david-b@pacbell.net> <20080222235628.GA31683@zarina>
In-Reply-To: <20080222235628.GA31683@zarina>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802221651.31216.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Anton Vorontsov wrote:
> > +static inline int gpio_request(unsigned gpio, const char *label)
> > +{
> > +     return -EINVAL;
> 
> Could we return -ENOSYS instead, so drivers will able to distinguish
> between "something really failed" and "there is no gpio support,
> fallback to other methods"? Without this, the notorious NAND driver
> will hardly benefit from this change. ;-)

Sure; that'll be gpio_request() and the gpio_direction_*() calls only
though, since those are the initial setup calls drivers make.

- Dave

