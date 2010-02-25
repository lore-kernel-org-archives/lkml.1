Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab0BYVon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:44:43 -0500
Received: from reaktio.net ([194.89.68.22]:53242 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934017Ab0BYVol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:44:41 -0500
Date: Thu, 25 Feb 2010 23:44:42 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Jens Seidel <jensseidel@users.sf.net>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: Re: CE: xen increasing min_delta_ns to 7651397591976463850 nsec /
	pvops domU
Message-ID: <20100225214442.GG2761@reaktio.net>
References: <20100222082657.GA26436@merkur.sol.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222082657.GA26436@merkur.sol.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

CCing to xen-devel..

-- Pasi

On Mon, Feb 22, 2010 at 09:26:59AM +0100, Jens Seidel wrote:
> Hi,
> 
> I'm using vanilla 2.6.32.7 domU kernel with Xen 3.2 and get very often a
> unresponsible system after approximately one or two days with messages such as
> 
> [43616.674502] CE: xen increasing min_delta_ns to 16086592372704132408 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 5683144485346646996 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 17748088764874746302 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 17398761110457343644 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 7651397591976463850 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 2253724351109919966 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 3380586526664879948 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 5070879789997319922 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 7606319684995979882 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 11409479527493969822 nsec
> [43616.674502] CE: xen increasing min_delta_ns to 17114219291240954732 nsec
> 
> on the console. I fail to login via ssh and even to cleanly shutdown this
> system via xm <id> shutdown. sysrq requests still work.
> 
> I searched the net but found only messages with 15000 nsec. My values are a
> little bit larger :-)) Found references to the kernel parameter notsc and
> tried it but the problem remains.
> 
> The problem started once I upgraded the kernel from 2.6.26 to 2.6.32.7.
> I changed from 32bit to 64bit but apart from this I did only a make oldconfig.
> That's why I think it's not my config which causes trouble.
> 
> Any ideas? Is it a known problem?
> 
> PS: Please CC: me.
> 

