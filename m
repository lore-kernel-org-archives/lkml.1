Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYCaF7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYCaF7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYCaF7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:59:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1055 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYCaF7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:59:36 -0400
Date: Mon, 31 Mar 2008 07:56:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
Message-ID: <20080331055618.GC23796@1wt.eu>
References: <47F0491F.4050804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F0491F.4050804@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:14:55AM +0800, Peter Teoh wrote:
> Interesting read:
> 
> http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf
> 
> Personal comments:
> 
> Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop 
> up - I don't see why it inhibits (in spite of the many initial 
> difficulties as mentioned in the paper) the growth of using Java for 
> device drivers development.   Contrast it against udev - esp in terms of 
> usability/supportability/extensibility etc.   udev is a Linux thing, 
> whereas Java is at industry level.   If everyone write applications 
> device drivers using Java (minus the extreme hardware arch specific 
> stuff, but supports all the low level protocol specific stuff like 
> TCP/IP, NFS, USB etc) then I think it has potential to compete against C 
> lang - the monopolizer till today in the kernel world 
> (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
> the Solaris in Linux, won't it be cool?

Oh fantastic! That way, we could have drivers which eat 1Gig of RAM for
almost nothing. Also, my experience with Java developers shows that what
Java really is is a way to lower the entry level in the development world.
That way, you can have completely incompetent people write complex
applications without even thinking that it will run on a real machine.
Most often, if it works in their IDE, they think it's OK to deploy (not
mentioning the fact that RFC compliance is far from being a problem in
these people's work). Of course, there are still real coders using this
language, and they may do great things (when the frameworks permit).

When you see salesmen announcing that their app will require about
400 GHz of CPU and half a TB of RAM to run, and noone even cares,
you understand there's a big problem with the way things are written
(the app that one was supposed to replace could run on 2 GHz of CPU
and 4 GB of RAM in the C version).

So please keep these technologies for sucking your nearby powerplant's
power and justifying your boss that you need a monster machine which
would make HPC people jealous, but I would hate it to make it easier
for the people I described above to pollute the kernel with their crap.

Willy

