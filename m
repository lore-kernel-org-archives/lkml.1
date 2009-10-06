Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZJFQvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZJFQvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZJFQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:51:08 -0400
Received: from bay0-omc3-s24.bay0.hotmail.com ([65.54.246.224]:63806 "EHLO
	bay0-omc3-s24.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbZJFQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:51:07 -0400
Message-ID: <BAY105-W30FA408F4CEAD3C272EC98C3CE0@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <jeff.chua.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <hugh@veritas.com>
Subject: RE: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Date: Tue, 6 Oct 2009 09:50:05 -0700
Importance: Normal
In-Reply-To: <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
X-OriginalArrivalTime: 06 Oct 2009 16:50:06.0215 (UTC) FILETIME=[0E9C4170:01CA46A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



> On Mon=2C 5 Oct 2009=2C Jeff Chua wrote:
>>
>> I've 3 systems with 4GB=2C 16GB and 64GB all running 32bit with these se=
t:
>
> Don't.
>
> 4GB is useable. 8GB is borderline. 16GB+ and nobody will care.
>
>> # with 64GB
>> total used free shared buffers cached
>> Mem: 63995 524 63470 0 4 365
>> Low: 378 32 345
>
> All your low memory is used for the 'struct page' arrays that describe
> everything else.
>
>> Anything I should do?
>
> Use a 64-bit CPU and kernel or limit your memory to 8GB or so. No ifs=2C
> buts and maybe's.
>
> Linus
Even Windows limits the amount of RAM to 16 GB when both PAE and it's 3G/1G=
 split mode is enabled for precisely the same reason.(It defaults to 2G/2G =
split mode)
See this for more info:http://blogs.msdn.com/oldnewthing/archive/2004/08/18=
/216492.aspx

Yuhong Bao 		 	   		  =0A=
_________________________________________________________________=0A=
Hotmail: Free=2C trusted and rich email service.=0A=
http://clk.atdmt.com/GBL/go/171222984/direct/01/=
