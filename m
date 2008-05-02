Return-Path: <linux-kernel-owner+w=401wt.eu-S937383AbYEBXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937383AbYEBXNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbYEBXNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:13:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43444 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935042AbYEBXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:13:46 -0400
Message-ID: <481BA025.8020804@firstfloor.org>
Date: Sat, 03 May 2008 01:13:41 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Moore, Eric" <Eric.Moore@lsi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B42@NAMAIL2.ad.lsil.com>
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B42@NAMAIL2.ad.lsil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Eric wrote:
> On Friday, May 02, 2008 4:50 PM, Andi Kleen wrote: 
>>> Here is a trace from pci express analyzer.   I'm sending
>> With what CPU/chipset was that?
>>
> 
> I'm developing sas driver for next generation controllers.  They should
> work at least on x86, x86_64, ia64, and ppc64.  The host I was using for
> gathering that trace was  x86_64 Intel Platform.  Here is the lspci
> output:

I doubt the CPU was to blame. Probably the chipset split it up for some
reason. Did you check the data sheets?

At the CPU level writeq is simply a 64bit store on x86-64 Linux.

-Andi
