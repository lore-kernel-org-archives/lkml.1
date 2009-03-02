Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbZCBTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbZCBTsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCBTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:48:46 -0500
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:44313 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754195AbZCBTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:48:45 -0500
X-Yahoo-Newman-Id: 720593.32864.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x4tePsaLRtymG6SPoKl3+/l477eHLj09FKdKmy+kGvRb+brtcEa5nGGQWjtrKzm/1q035r4GwgT/sYEvygrC5wPK6pGiciQug22FAVRGU+d4qY0NUYTsuCMZiIUDFtg0+mp5fNZttUU1sfAe5ZG+VcVVVk1c1uBobFzMEgS84JA=  ;
X-YMail-OSG: bN0YZKwVM1le6iA2be8wuJhVK1lMr0cWBqPGR1EaRRh9dkKJvxxSt3c_B.ThIJLPq8PVs7y0JHnHBe.67S7updns1aXGwLPkgP52toUS4NzMbEHO_m.lhSp3fhR2Wq9azKIJU5f1RGd2Wsqo9qAbzh9vJ6QZGWKIj9hyfJSlhlXUyzoSRo3akCUwdOMY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] genirq: assert that irq handlers are indeed run in hardirq context.
Date: Mon, 2 Mar 2009 11:48:40 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902271518.58246.david-b@pacbell.net> <1236006812.5330.632.camel@laptop>
In-Reply-To: <1236006812.5330.632.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021148.41405.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> > But these handlers are *NOT* running in hardirq context;
> 
> Ah, let us stop this tinkering dead in its tracks

How about providing adequate support for threaded IRQs
first, before breaking code that's been working for the
last few years?

This patch fails the "no regressions" test.  And with
no reason given -- not even a bad one.

For what it's worth:  NAK.

- Dave



