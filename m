Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYHELTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYHELTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759720AbYHELTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:19:11 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52836 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760667AbYHELTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:19:09 -0400
X-SourceIP: 212.186.3.226
Message-ID: <489836D3.2050008@chello.at>
Date: Tue, 05 Aug 2008 13:17:39 +0200
From: "alois.klingler@chello.at" <alois.klingler@chello.at>
Reply-To: alois.klingler@chello.at
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ondrej Zajicek <santiago@crfreenet.org>, MadLoisae@gmx.net,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: kernel oops with framebuffer device vt8623fb
References: <487E2911.5090701@gmx.net>	<20080717013917.GA1695@localhost.localdomain> <20080728204817.ebaa621b.akpm@linux-foundation.org>
In-Reply-To: <20080728204817.ebaa621b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This issue is still not fixed in 2.6.26.1 - may be there a way to commit 
it in 2.6.26.2?

Still, the provided patch I got on 07/17/2008 works great ...

Thanks, anyway!

kind regards, Alois


Andrew Morton wrote:
> On Thu, 17 Jul 2008 03:39:18 +0200 Ondrej Zajicek <santiago@crfreenet.org> wrote:
>
>   
>> On Wed, Jul 16, 2008 at 07:00:02PM +0200, MadLoisae@gmx.net wrote:
>>     
>>> Hi!
>>>
>>> I've updated my machine from 2.6.25.11 to 2.6.26 and I think I've found 
>>> a problem.
>>>
>>> If I load the module vt8623fb i get a kernel oops, if the VIA 8623 
>>> display framebuffer driver is compiled direct into kernel the system 
>>> hangs up very early at booting the kernel.
>>>       
>> I am sorry for mistake, here is a patch for 2.6.26 fixing the bug:
>>
>> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
>>     
>
> I went back through the email thread and wrote your changelog for you. 
> Not a very good one though.
>
> It would be better were you to write your changelogs, please.
>
>
>   

