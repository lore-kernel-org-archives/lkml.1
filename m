Return-Path: <linux-kernel-owner+w=401wt.eu-S1763706AbXK3Tfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763706AbXK3Tfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXK3Tfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:35:42 -0500
Received: from smtpoutm.mac.com ([17.148.16.71]:62230 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbXK3Tfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:35:41 -0500
In-Reply-To: <47505907.5030409@zytor.com>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <47505907.5030409@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <02B4DDE5-3D53-4BA5-BB79-52788CEBB9AF@mac.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Kernel Development & Objective-C
Date: Fri, 30 Nov 2007 14:35:34 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007, at 13:40:07, H. Peter Anvin wrote:
> Kyle Moffett wrote:
>> With that said, there is a significant performance penalty as all  
>> Objective-C method calls are looked up symbolically at runtime for  
>> every single call.
>
> GACK!
>
> At least C++ has vtables.

In a tight loop there is a way to do a single symbolic lookup and  
just call directly through a function pointer, but typically it isn't  
necessary for GUI programs and the like.  The flexibility of being  
able to dynamically add new methods to an existing class (at least  
for desktop user interfaces) significantly outweighs the performance  
cost.  Any performance-sensitive code is typically written in  
straight C anyways.

Cheers,
Kyle Moffett

