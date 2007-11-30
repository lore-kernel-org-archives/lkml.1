Return-Path: <linux-kernel-owner+w=401wt.eu-S935182AbXK3PE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182AbXK3PE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbXK3PEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:04:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbXK3PEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:04:21 -0500
Message-ID: <47502595.4020007@redhat.com>
Date: Fri, 30 Nov 2007 10:00:37 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ben.Crowhurst@stellatravel.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk>
In-Reply-To: <474EAD18.6040408@stellatravel.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Crowhurst wrote:
> Has Objective-C ever been considered for kernel development?

No.  Kernel programming requires what is essentially assembly language with a 
lot of syntactic sugar, which C provides.  Higher-level languages abstract away 
too much detail to be suitable for the sort of bit-perfect control you need when 
you're directly controlling bare metal.  You can still use object-oriented 
programming techniques in C, and we do this all the time in the kernel, but we 
do so with more fine-grained explicit control than a language like Objective-C 
would give us.  More to the point, if we tried to use Objective-C, we'd find 
ourselves needing to fall back to C-style explicitness so often that it wouldn't 
be worth the trouble.

In other news, I hear Hurd boots again!

	-- Chris
