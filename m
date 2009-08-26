Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZHZH3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZHZH3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZHZH3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:29:49 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50198 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbZHZH3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BbxFps5ubQh/o/ZH5Z3MCWHeeWgq/QcWN+zkKibo59PYlETPbdbmXoBr91KUx5v8Hs
         g5ag686ckel1wFWkdL21H+BCZ3C8YbrfmL0uAPe7P69oBPTnNr5joWF+4YkdPMkBFy2/
         YwKjpQ8HWkM7I+SFanTZpGF38wRszh6bx6BXc=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251264700.7538.1178.camel@twins>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:29:58 +0300
Message-Id: <1251282598.3514.20.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-08-26 at 07:31 +0200, Peter Zijlstra wrote:
> On Tue, 2009-08-25 at 13:22 -0600, Chris Friesen wrote:
> > On 08/25/2009 01:08 PM, Peter Zijlstra wrote:
> > 
> > > Christoph, stop being silly, this offline scheduler thing won't happen,
> > > full stop.
> > > 
> > > Its not a maintainable solution, it doesn't integrate with existing
> > > kernel infrastructure, and its plain ugly.
> > > 
> > > If you want something work within Linux, don't build kernels in kernels
> > > or other such ugly hacks.
> > 
> > Is it the whole concept of isolating one or more cpus from all normal
> > kernel tasks that you don't like, or just this particular implementation?
> > 
> > I ask because I know of at least one project that would have used this
> > capability had it been available.  As it stands they have to live with
> > the usual kernel threads running on the cpu that they're trying to
> > dedicate to their app.
> 
> Its the simple fact of going around the kernel instead of using the
> kernel.
> 
> Going around the kernel doesn't benefit anybody, least of all Linux.
> 
> So its the concept of running stuff on a CPU outside of Linux that I
> don't like. I mean, if you want that, go ahead and run RTLinux, RTAI,
> L4-Linux etc.. lots of special non-Linux hypervisor/exo-kernel like
> things around for you to run things outside Linux with.
Hello Peter, Hello All.
First , It a pleasure seeing that you take interest in OFFSCHED. 
So thank you. 

To my opinion this a matter of defining what a system is. Queuing theory
teaches us that a system is defined to be everything within the boundary
of the computer, this includes, peripherals, processors, RAM , operating
system, the distribution and so on.  
The kernel is merely a part of the SYSTEM, it is not THE SYSTEM; and it
is not a blasphemy to bypass it.The kernel is not the goal and it is not
sacred. 
OFFSCHED is bad name to my project. My project is called SOS = Service
Oriented System.
SOS, has nothing to do with Real time. SOS is about arranging the
processors to serve the SYSTEM the best way we can; if the kernel
disturbs the service, put it a side I say. 

How will the kernel is going to handle 32 processors machines ?  These
numbers are no longer a science-fiction.

What i am suggesting is merely a different approach of how to handle
multiple core systems. instead of thinking in processes, threads and so
on i am thinking in services. Why not take  a processor and define this
processor to do just firewalling ? encryption ? routing ? transmission ?
video processing... and so on... 

Raz



 
 







