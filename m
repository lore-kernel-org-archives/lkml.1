Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYDKRGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYDKRGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbYDKRF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:05:59 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43916 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760214AbYDKRF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:05:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pf+wtYSfD6y+qY1S7o4Ae5dvxiyr9VtqSSKkdRnWk7mMQXy1ekOzjoCVwjBl1vkt2QhOsR6TUCU7ZVItoaneszeeiHm2VBKId5AqP2q3vhy8OtlE/Ev2fKtFP0m+4XCgWd1JHQXlYeJdhr1V5wqQV/Aj86zdejwob7bs6li4gQg=  ;
X-YMail-OSG: d4F_aakVM1m5zqZ6f6fW3nPGjJswYdmmq66dQsdemVBdvHiZkV5PFzashdy0.fV0cr1zQ3Iz4g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] GPIO: #include <linux/kernel.h> for might_sleep
Date: Fri, 11 Apr 2008 10:05:51 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
In-Reply-To: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804111005.52041.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008, Uwe Kleine-König wrote:
> I like having headers being independend of the order of inclusion.

That's a pretty unusual policy.  Not one that's generally
followed in the kernel, either ... 


> Usually I order all includes alphabetically (and grouped by linux/,
> asm/, etc.). 

If you like alphabetical, why the exception for <asm/...> ??
:)


> This doesn't work with gpio.h because then kernel.h is 
> included to late.

So include <linux/kernel.h> first.  There *is* a policy
of avoiding extra #includes ... extras slow down builds.

- Dave
