Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYCODsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYCODsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYCODsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:48:08 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:48031 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751733AbYCODsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:48:07 -0400
Message-ID: <47DB46F1.80106@gawab.com>
Date: Fri, 14 Mar 2008 20:48:01 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803131009.01889.jbarnes@virtuousgeek.org> <47D9FD71.5080909@gawab.com> <200803141029.38124.jbarnes@virtuousgeek.org>
In-Reply-To: <200803141029.38124.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:

> It would be interesting if you could get register dumps at a couple of 
> different points, using the intel_reg_dumper tool in 
> git://git.freedesktop.org/git/xorg/driver/xf86-video-intel (in 
> src/reg_dumper).
>   
I couldn't get it to compile. What am I suppose to do? I ran autogen.sh 
in the top level dir and it gave the error message:

./configure: line 20486: syntax error near unexpected token `XINERMA,'
./configure: line 20486: `XORG_DRIVER_CHECK_EXT(XINERMA, xineramaproto)'

Then I also tried to run make and make -f Makefile.in (in the reg_dumper 
dir and top level dir), and it said:

Makefile.in:15 *** missing separator. Stop.

That part of Makefile.in contains:
@SET_MAKE@
VPATH = @srcdir@

What am I doing wrong? You'll have to forgive me, I'm not that 
experienced with the cmd line and compiling - I'm trying though.

> You'll probably have to modify your boot scripts though.  
> It would be good to get them:
>   - at startup time before the splash screen
>   - sometime while the splash screen is running
>   - after X starts and you see the blank screen
>   
How exactly would I do that? I would think I could just add command at 
the end of 3 files in /etc/init.d. Would that work? It should run my 
command when it starts that script and gets to the end. Or do boot 
scripts exit in the middle of the script, which would prevent my command 
from running?
> What's different between your Uni. environment and your home environment?
I'm not sure. I just have a home wireless router (Hawking HWR54G). I 
have no idea what the Uni. router is.
On both, I connect to an unencrypted network, but at the Uni. it 
redirects to a login page where I have to log on before I can actually 
use the Internet. Is there anyway I could get more information about the 
Uni. router?

Justin
