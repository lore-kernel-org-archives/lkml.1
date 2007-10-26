Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXJZO6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXJZO6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXJZO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:58:16 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:35337 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751366AbXJZO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:58:15 -0400
Message-ID: <4722006E.30709@manicmethod.com>
Date: Fri, 26 Oct 2007 10:57:50 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory
 Access Control Kernel
References: <47201183.1090107@schaufler-ca.com>
In-Reply-To: <47201183.1090107@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 14:58:13.0725 (UTC) FILETIME=[A1F350D0:01C817E0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> The Smack patch and Paul Moore's netlabel API patch,
> together for 2.6.24-rc1. Paul's changes are identical
> to the previous posting, but it's been a while so they're
> here again.
>
> The sole intent of change has been to address locking
> and/or list processing issues. Please don't hesitate to
> point out any problems that you might see or suggest
> alternatives where things might not be to your liking.
>
> This version is aimed at 2.6.24, and has been tested
> against 2.6.24-rc1.
>
> Thank you again.

For some reason I didn't get 2/2 so I can't make an inline comment but 
one thing I noticed while trying to build a smack kernel is that smack 
has a kconfig dependancy on NETLABEL and SECURITY_NETWORK. This is 
unfortunate because user X wanting to try out smack won't see it in the 
config until he goes and enables those things (which he wouldn't know 
about without reading the smack Kconfig). It would be nice if those were 
selects instead.

