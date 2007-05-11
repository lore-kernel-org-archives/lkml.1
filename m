Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbXEKUai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbXEKUai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbXEKUab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:30:31 -0400
Received: from mta11.adelphia.net ([68.168.78.205]:46901 "EHLO
	mta11.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbXEKUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:30:31 -0400
Message-ID: <4644D264.3090200@acm.org>
Date: Fri, 11 May 2007 15:30:28 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Patrick Schoeller <Patrick.Schoeller@hp.com>
Subject: Re: [PATCH] IPMI: fix SI address space settings
References: <20070511125616.GA6422@localdomain> <20070511125929.7000f9d8.akpm@linux-foundation.org>
In-Reply-To: <20070511125929.7000f9d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 11 May 2007 07:56:16 -0500
> Corey Minyard <minyard@acm.org> wrote:
>
>   
>> Fix a rather obvious error that Patrick found in the setup routines.
>> Need to set the proper address space in the ACPI case.
>>     
>
> I have assumed that both these fixes are desired in 2.6.21.x.
>   
The ACPI fix can go to 2.6.21.x.

The PPC openfirmware one is a fix for a patch that just went in for 
2.6.22.  So that one doesn't need to be put in 2.6.21.x.
> In general, it helps if people can think about that and express an
> explicit opinion when sending fixes, please.
>   
Will do.  Thanks.

-corey
