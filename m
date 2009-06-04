Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZFDJGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZFDJGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZFDJGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:06:44 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:34458 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753580AbZFDJGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:06:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J8R5I+VhEpDhgqGjmHtp/NDdBUmd8jlanxzlvHa1+gWr2RJ60OpNFfZqmdT/vlWKFzmTdfsq0y/WNGyH5tvHaa/ZS7k/ol0u1qzlZFd7c+uQHXgC+mjkjQS2QWNdqsP5NS98Ftq9gp26EQQBgVGkyc7hZIp6kC2ZsnxicmMIv+A=  ;
X-YMail-OSG: QLHvYAIVM1lrDLEmy4ToW87Ifewcna_Ho8xIpClswAUtJZW3qMQ_ydlpe0GcIhsn9_CsGyO9UkP9jgjbdQ7RKrAN8VzZ8HOHqYhvyUKX17oYp1MUGwdgc4b4yp1khYmQynGNu8uVmrdROfptZbQaYzvjmL_J7Up_V.YMquQJKzlZH9NfPBGN4XIha9a2wBsHPA10iRSJUXlXd0SrAnJKpBOSnH7IMYtO6Jpg48rg1wFXmbuiEyDgi_pTrhVDTaOYcHiJBbqMYjjJEaM4__dzJs.8WSDAQgpWmPdeUQEqnlr254PQ.24-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Date: Thu, 4 Jun 2009 02:06:43 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org> <200906040127.24740.david-b@pacbell.net> <8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
In-Reply-To: <8bd0f97a0906040152h1fa57f5crd96faa37322a1b40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906040206.44144.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Mike Frysinger wrote:
> my next request was for a 1 letter command set and chaining
> operations.  say you want to toggle a gpio line 4 times, having to go
> between kernel and userspace for that seems kind of heavy.
> echo TTTT > value

Having that kind of stuff in kernelspace seems wrong;
if you're going that route, embed Guile or something.  ;)

The "TTTT" thing could as easily be scripted in BASH.


