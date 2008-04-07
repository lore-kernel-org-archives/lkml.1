Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYDGKZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYDGKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYDGKZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:25:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50217 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428AbYDGKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:25:51 -0400
Message-Id: <1207563950.7880.1246457209@webmail.messagingengine.com>
X-Sasl-Enc: w6P3LeprDVbjjCuAivnWNEGHl1Yy3AYytF38kPxdWKQZ 1207563950
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "dean gaudet" <dean@arctic.org>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu>
   <20080401094618.GA24862@mailshack.com>
   <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
   <1207507897.18129.1246358115@webmail.messagingengine.com>
   <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert    
   i386
In-Reply-To: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
Date: Mon, 07 Apr 2008 12:25:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 6 Apr 2008 13:22:58 -0700 (PDT), "dean gaudet" <dean@arctic.org>
said:
> On Sun, 6 Apr 2008, Alexander van Heukelum wrote:
> 
> > The current generic implementation of ffz is O(lg(n)) already
> 
> it's O(lg(n)) time... the operations all depend on each other.
> 
> the implementation i pointed to is O(lg(n)) code space... and the time 
> depends on how parallel the machine is, they're not dependent on each 
> other.

Indeed. The worst dependencies are in the sum of all the partial
results in this implementation. And addition is associative, so
partial results can be written as ((a+b)+(c+d))+(e+f). Assuming
perfect parallel execution this would lead to O(ln(ln(n))). Good.

Care to implement ffs and __ffs like this?

Greetings,
    Alexander

> -dean
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - The professional email service

