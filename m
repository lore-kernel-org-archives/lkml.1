Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYJZD3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYJZD3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 23:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYJZD2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 23:28:52 -0400
Received: from 1wt.eu ([62.212.114.60]:4933 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYJZD2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 23:28:52 -0400
Date: Sun, 26 Oct 2008 04:27:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Hartmut Niemann <Hartmut.Niemann@gmx.de>
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au,
       nico-kernel-nfsroot@schottelius.org
Subject: Re: nfsroot.txt in 2.4.36.7 and 2.6.27.1, Configure.help in 2.4.36.7: missing precondition CONFIG_IP_PNP
Message-ID: <20081026032711.GV24654@1wt.eu>
References: <200810252347.01484.Hartmut.Niemann@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810252347.01484.Hartmut.Niemann@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 25, 2008 at 11:47:01PM +0200, Hartmut Niemann wrote:
> Hello everybody!
> 
> In kernel versions 2.4.36.7 and 2.6.27.1 (I checked only these) the file 
> nfsroot.txt fail to mention, that
> Kernel level autoconfiguration CONFIG_IP_PNP *must* be selected
> (in 2.6.27.1 the wording is much better mentioning that nfs may not be
> compiled as a module than in 2.4.36.7) 
> in order to be able to even *see* the option
> "Root file system on NFS" (CONFIG_ROOT_NFS)
> -- except for xconfig in 2.4.36, which allowed me to see that there is 
> this option (greyed), and to see it's help text. (This, by the way,
> was a big help -- I could see that the option is still present in current
> kernels)

Kbuild in 2.6 is much more evolved than in 2.4 as it knows about
dependencies, and tells the user what needs to be enabled for each
option. It's true that xconfig is sometimes helpful on 2.4 for this
reason, but I tend to grep for the option rather than starting xconfig.

> I reordered the section 1 of nfsroot.txt (of 2.6.27.1), diff is attached.
> (And I fixed some chapter numbering in section 3).
> Is this document otherwise correct for 2.4 and can be updated there too?
> The version in 2.4.36.7 is 
> 
> The help text of CONFIG_ROOT_NFS in 2.4.36.7 is quite funny:
>   "It is
>   likely that in this case, you also want to say Y to "Kernel level IP
>   autoconfiguration" so that your box can discover its network address
>   at boot time."
> Does that make clear that you can not even see this option 
> during make *config unless you set "Kernel level IP autoconfiguration"?
> The help text of CONFIG_NFS_FS does contain the information,
> but I found it there a little late. The texts in 2.6 are better.
> 
> A diff for 2.4.36.7 Configure.help is attached as well.
> 
> Is this correct?

Your explanation seems correct, but it only explains better the option
which you couldn't find. So you still have to enable it first in order
to find how to enable it :-/  I've just checked the help for CONFIG_NFS_FS,
and it is quite clear about the fact that you need to enable IP autoconfig
to enable NFS ROOT. Maybe it is this section which should be enhanced to
tell where to enable those options ?

Willy

