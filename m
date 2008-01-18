Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbYARNWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbYARNWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYARNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:22:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53025 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbYARNWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:22:35 -0500
Date: Fri, 18 Jan 2008 14:22:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: build #343 issue for v2.6.24-rc8-29-g03bbe08 : Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
Message-ID: <20080118132242.GA18183@uranus.ravnborg.org>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080118125144.GI2559@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 08:51:44PM +0800, WANG Cong wrote:
> On Fri, Jan 18, 2008 at 01:46:27PM +0100, Sam Ravnborg wrote:
> >On Fri, Jan 18, 2008 at 08:29:17PM +0800, WANG Cong wrote:
> >> On Fri, Jan 18, 2008 at 01:18:27PM +0100, Toralf Förster wrote:
> >> >Hello,
> >> >
> >> >the build with the attached .config was successful however I got during make :
> >> >  AS      .tmp_kallsyms2.o
> >> >  LD      vmlinux.o
> >> >  MODPOST vmlinux.o
> >> >WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
> >> >  CHK     include/linux/version.h
> >> >  HOSTCC  scripts/unifdef
> >> >  MKDIR   include
> >> >
> >> >Does it help / make sense to report such warning ?
> >> >
> >> >The build was made with :
> >> >$> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make
> >> >
> >> >Here's the config:
> >> 
> >> Thanks. You have reported this. ;)
> >> 
> >> I can't solve this problem. Let's Cc Rusty and Sam to see
> >> if they can solve this.
> >
> >modpost gets confused by the section named ".init.text.1" - the additional '.1'
> >is unexpected.
> >
> >Following untested patch should fix it.
> >
> 
> Still has the same problem. ;(
Could you please doublecheck that you applied the patch and modpost is rebuilt.
If you continue to see the problem could you send me the config (off-list) and
I will fix it.

	Sam
