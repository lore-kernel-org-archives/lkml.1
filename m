Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbXLAUCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbXLAUCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXLAUCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:02:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:59993 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXLAUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:01:59 -0500
Message-ID: <4751BD23.7020104@argo.co.il>
Date: Sat, 01 Dec 2007 21:59:31 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca>
In-Reply-To: <20071130143445.GA2310@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, Nov 29, 2007 at 12:14:16PM +0000, Ben Crowhurst wrote:
>   
>> Has Objective-C ever been considered for kernel development?
>>     
>
> Doesn't objective C essentially require a runtime to provide a lot of
> the features of the language?  If it does (as I suspect) then it is
> totally unsiatable for kernel development.
>
>   

C also requires a (very minimal) runtime. And I don't see how having a 
runtime disqualifies a language from being usable in a kernel; the 
runtime is just one more library, either supplied by the compiler or by 
the kernel.

>
> Besides the kernel does a wonderful job doing object oriented design
> where apropriate using C without any of the stupidities added by the
> common OO languages

Object orientation in C leaves much to be desired; see the huge number 
of void pointers and container_of()s in the kernel.
