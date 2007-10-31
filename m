Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbXJaD0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbXJaD0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJaD0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:26:35 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:45701 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751944AbXJaD0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:26:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lyHEuvOGZEQT3Jhy1jb0lYEpsMWpB4u97enk77p2/XKGtFsPEwcNpg5Xsmp9nUscpPXj41vtjplT4YX5cS8tvZQJYGgD3qIISMATE+vo0URHZph3GjK4zMQuA1g1XD9JEyxmHnCyVwsFUvlyQTjwIRIhHN5Q9KVOPMiLllghKps=  ;
X-YMail-OSG: ZzK0wVEVM1nl0wCwG6hXku1_2_sAUoE0tpuumiC7blQ6PMd1Z_bYWnkUd2o6XA87ozMNK42Iju..pnVNcYlLk3QTeQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Lorenzo Allegrucci" <l.allegrucci@gmail.com>,
       "=?iso-8859-1?q?Bj=F6rn?=" <askadar@gmail.com>
Subject: Re: 2.6.23 performance regression
Date: Wed, 31 Oct 2007 13:19:53 +1100
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <4dcf7d360710300054m7ac77445pf786bd9044b572d7@mail.gmail.com>
In-Reply-To: <4dcf7d360710300054m7ac77445pf786bd9044b572d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311319.54210.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 18:54, Lorenzo Allegrucci wrote:
> Hi, sorry if this is a faq but reading
> http://people.freebsd.org/~kris/scaling/7.0%20Preview.pdf (slides 17,
> 18)
> looks like 2.6.23 is having a performance regression on MySQL and
> PostgreSQL benchmarks.  Has anyone investigated these?

I think Ingo was looking into them. I'm just in the middle of
building a new setup to investigate some performance issues too,
so I hope to look at this.

Apparently it did go unnoticed during CFS testing, unfortunately.
Although now it has been brought to light, I think 2.6.24 is
supposed to be better (although it now gets worse on other things).
