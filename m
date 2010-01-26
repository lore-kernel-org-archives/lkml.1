Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143Ab0AZVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0AZVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699Ab0AZVBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:01:21 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:20803 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752640Ab0AZVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:01:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=alczl/u9rIWSK7TepgvlLGXsp6qlVk5UoY2mdji0jD5JT+58ZK18CTF6EYrSDx7aZHidFJ6ZrRZ22tjgDuMNMINLu1KD2t925AxEVhyCAatyaPPDTg8qJ2JAY/YFjISu56ZzcBXdr0F8GqaYJpW067mcuIXUBb5YnWP1PrxbEaE=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Aiyga9UVM1mUhjNBIUFFEs2_uFsD.sZHlh1x9VmhvXtMUOCeSX1iZi9nPOw_h1C_tz41tETmXrKmyGlY8uiP8KDaPc1Qyd3RPyJ.2veQqvNNICKiAwgEb.Vqboq6vXRKmnduS0XuYlj.qDlVLQTRknNZYiJQMb5TneHPtPZbfXkK.AZyOAIkQq3DepHjqDlOY6V1I49oMWKAg3UlRpvZJnp4DiWKxiW7vKHbw0YqFzKrIDalggg0BWneqItoN138
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
Date: Tue, 26 Jan 2010 13:01:05 -0800
User-Agent: KMail/1.9.10
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru> <201001252234.30169.david-b@pacbell.net> <20100126172824.GA20319@oksana.dev.rtsoft.ru>
In-Reply-To: <20100126172824.GA20319@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001261301.05475.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Anton Vorontsov wrote:
> > Just
> > inline the little two blocking_notifier_call_chain() calls directly,
> > making this a *LOT* simpler.
> 
> I'd rather stay with gpio_call_chain() helper, it makes the code
> a little bit prettier, IMO. Compare this:

The one without the wrapper is IMO more clear, since it doesn't
obfuscate anything.  Fewer lines of code, too.  :)

Pretty is a good attribute ... but is a distant third to clarity.

