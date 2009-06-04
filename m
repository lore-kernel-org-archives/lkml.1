Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZFDJP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZFDJP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbZFDJPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:15:48 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:37221 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757923AbZFDJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:15:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hxBBYLC4C3KnBstaFhIArMwk9jGXgptECplrrV9arbH7behpvZjbRuvH4OxdNgDY3mILGzHPuggrkFozy9JqDDAOGmietrK++YPE7J3qmQTegDsaPyECuoJgCWxDqZAsTqJD3C1lBuVpzyIAcHdsqky4xZ9ZE2bIjNYPfySflzw=  ;
X-YMail-OSG: w..LJBcVM1kDaIa4knFmP.CT3FysWZVUxYIP.PdWLeyxb9txIDh4BldhC4_JrwiEvD21H0NuDwMdPH6Gf3woQBVS1WMhSlUbpwr4mpkLDNJF3SDjoUcy7Jse.a3vOl.8inFW9K8mghmc_cVWPrsFHXdIyq9crr8x3OCEQWbLH3CjZBntgsCKa1eoFklucHBCA2Oo14Sm7YvbnT0X0AdR8hYvBOMYS9FDwa5mBMayF7R3Di.XZ.2tnaxgHPP6YY4tTdymva1204lqp3SSQlM7nKthZwE0TlOhdkC5xZdmKjJ2EHgVTkk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Date: Thu, 4 Jun 2009 02:15:48 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org> <200906040206.44144.david-b@pacbell.net> <8bd0f97a0906040209r269fe700hffd0cdcba264ca0b@mail.gmail.com>
In-Reply-To: <8bd0f97a0906040209r269fe700hffd0cdcba264ca0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906040215.48264.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Mike Frysinger wrote:
> the point was to lower the number of user<->kernel transitions.  yes,
> all of this stuff can of course be done in the shell, but it's hard to
> push limits when the interface is tying your hands and sitting on your
> back.

So what's the application that needs to do all this in
userspace yet which can't hook up a quick kernel driver?

I don't like the idea of embedding any kind of interpreter
in the sysfs interface, but that's the direction you seem
to be heading ...




