Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXLUMYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXLUMYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXLUMYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:24:31 -0500
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:1392 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbXLUMYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:24:30 -0500
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 07:24:30 EST
Message-ID: <476BACD6.5060900@superbug.co.uk>
Date: Fri, 21 Dec 2007 12:08:54 +0000
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>	<20071219202323.GH2310@csclub.uwaterloo.ca>	<Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>	<20071220150255.GE2308@csclub.uwaterloo.ca>	<Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>	<20071220182815.GA5438@uranus.ravnborg.org>	<Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>	<20071220220547.GA5641@uranus.ravnborg.org>	<Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com> <20071221005303.771032f3@werewolf>
In-Reply-To: <20071221005303.771032f3@werewolf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
>>>>
>>>> I need to get rid of -mregparm=3 on gcc's command line. It
>>>> is completely incompatible with the standard calling conventions
>>>> used in all our assembly-language files in our drivers. We make
>>>> very high-speed number-crunching drivers that munge high-speed
>>>> data into images. We need to do that in assembly as we have
>>>> always done.
>>>>         
>
> Just for curiosity... yep, I understand now you have everything written
> in assembler, but why not consider start writing it in C and stop
> doing the compiler work (such as pipelining, out of order reordering,
> loop unrolling for specific processor, and so on...)
>
> That's what everyone taught me, nowadays you won't be better than the
> compiler in anything longer than three lines...
>
>   

Not true for image processing. compilers are not too good with 
optimizing mmx and sse algorithms. This is why user space libraries like 
ffmpeg still use assembly code.
That being said, I don't think sse and mmx are available in kernel 
space, so I would have suggested doing all the grunt work in userspace 
would be better for this persons application so that he could use sse 
and mmx etc.

James

