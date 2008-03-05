Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYCEGKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYCEGKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYCEGKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:10:31 -0500
Received: from 1wt.eu ([62.212.114.60]:2253 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYCEGK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:10:29 -0500
Date: Wed, 5 Mar 2008 07:09:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: sam@ravnborg.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       vegard.nossum@gmail.com
Subject: Re: kernelprojects::menuconfig [was:Re: Google's Summer of Code?]
Message-ID: <20080305060927.GF8953@1wt.eu>
References: <84144f020803041045i70bbb05l6983bd14c5bcc91a@mail.gmail.com> <alpine.LFD.1.00.0803041127290.12253@woody.linux-foundation.org> <84144f020803041155k222c13ecu13c8c9534ced87e5@mail.gmail.com> <20080304121339.a3b2483f.akpm@linux-foundation.org> <Pine.LNX.4.64.0803042216030.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0803042216030.7660@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:44:39PM +0100, Jan Engelhardt wrote:
> Hi Sam,
> 
> 
> On Mar 4 2008 12:13, Andrew Morton wrote:
> >"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> >
> >> I am also wondering if such a high profile
> >> project as the kernel can get away with not having a "project ideas"
> >> list which would make things real easy for the administrator(s)...
> >
> >http://kernelnewbies.org/KernelProjects
> >
> 
> ["""Update menuconfig to a modern ncurses look & feel
> 
> htop, aptitude, tig and other ncurses based programs has a more modern 
> and effective look&feel than current menuconfig. Rip out all the 
> lxdialog stuff and replace it with a ncurses based frontend that looks 
> better and has more functionality."""]
> 
> 
> I remember the last discussion about it, and I am still kinda in the 
> position of "really?". I find the current menuconfig interface 
> perfectable suitable.
> 
> I could not relate how menuconfig should look htop-style, because htop, 
> for the most use, is just one screen with a process overview and a 
> rather spartan "menu", should one decide to change some configuration 
> options. Essentially it is a 4-column expand-to-the-right menu. No idea 
> how to put it better.
> 
> aptitude. I only seen it very briefly since I do not use Debian. I can 
> probably say the package selection in the OpenSolaris initial installer 
> is similar, in other words, _all_ CONFIG options are listed in 
> tree-style fashion in one window...
> 
> 	> [ ] feature1
> 	  [ ] . . . feature2
> 	  [ ] . . . feature3
>         > [ ] feature99
> 
> something like that. Anyway, I dislike the tree (expandable and 
> contractable at will at the > points) ??? menuconfig seems superior
> since, after entering a new submenu, just the options inside it are
> displayed and nothing around it.
> 
> Then there are splitscreen approaches like qconfig/xconfig do, 
> and I think I would not like that either for menuconfig; moving between 
> two panels (one: the menu selection as a tree, the other: options for 
> this submenu) is, kinda confusing in a text environment.
> 
> Of course there is a plus point for the tree-in-one (aptitude) approach 
> in that searching for options/features is easier. The current menuconfig 
> has a limited search function, for example, it will not take you to the 
> option you searched but return to the menu you started the search from. 
> Which means you have to repeatedly search for the option because you 
> cannot remember the menus you have to go through to reach the option.
> 
> My stance: remain with the current menuconfig, and improve on the 
> search(-and-jump) function.
> 
> Awaiting your counter-arguments and -opinions please.

100% agreed with you Jan, menuconfig is excellent. I was even thinking
that it would be really cool if someone could extract Kbuild from the
kernel and produce an independant framework to make it easier to include
in other projects. I would really like to be able to launch a "make
menuconfig" or "make oldconfig" with my own softs, and see only what
has changed being rebuilt. Think about all the people who get nervous
when "./configure" does not produce what they want...

Another project I was thinking about is a "smart" patch utility. Right
now, "patch" works line by line. While this may be understandable for
"patch", it's pretty annoying to see the same behaviour in "merge".
Why not have a smarter pair of tools which would be able to detect
changes in consecutive lines, or even merge changes on the same line ?
merge cannot even merge two changes on consecutive makefile entries
right now, which has an impact on git's ability to merge changes.
For instance, as an exercise to teach git to a friend, I used the
following file :

a=1
b=1
c=1

Then, branch b changes b=1 to b=2, and branch c, c=1 to c=2. You cannot
merge them automatically, which is a shame. So there is room for improvement
here :-)

Regards,
Willy

