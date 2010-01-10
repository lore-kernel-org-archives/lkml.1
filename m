Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452Ab0AJUFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0AJUFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535Ab0AJUFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:05:19 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:47688 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab0AJUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:05:18 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 15:05:18 EST
Message-ID: <4B4A2DAA.2050104@superbug.co.uk>
Date: Sun, 10 Jan 2010 19:42:34 +0000
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091213 Thunderbird/3.0
MIME-Version: 1.0
To: "Paul G. Allen" <pgallen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
In-Reply-To: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/10 18:57, Paul G. Allen wrote:
> I am wondering, have there been any performance tests comparing Linux
> serial IO to Windows and what was the result? Is it a problem in the
> comm API (e.g. - the Windows DLL having better performance than the
> Linux .so)? Is it a problem in the Linux serial driver itself? Is
> there something I can/need to do on Linux to tweak the driver and make
> it faster?
>
> Thanks,
>
> PGA
>   
If you can narrow down the problem, one might be able to help.
I would suggest that you write a test Java program that both sends and
receives data on the same port and then post that source code to the list.
Anyone can then plug in a serial loopback connector, and  reproduce the
problems you observe.

Without any way to reproduce the problems you observe, there is very
little chance of fixing it.
I suspect the problem is probably due to interrupts and serial buffer sizes.

As an aside, I would probably have used usb instead of serial as the
interface. It would be faster but not a lot more expensive.

Kind Regards

James



