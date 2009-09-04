Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZIDQjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZIDQjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZIDQje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:39:34 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:40253 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbZIDQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:39:33 -0400
Date: Fri, 4 Sep 2009 09:38:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, sam@ravnborg.org,
       tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
Message-Id: <20090904093846.a87bd198.randy.dunlap@oracle.com>
In-Reply-To: <4AA13FE6.20807@zytor.com>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>
	<20090904144857.GA12872@elte.hu>
	<alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org>
	<4AA13FE6.20807@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AA1429A.0013:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Sep 2009 09:27:18 -0700 H. Peter Anvin wrote:

> On 09/04/2009 08:33 AM, David Woodhouse wrote:
> > On Fri, 4 Sep 2009, Ingo Molnar wrote:
> > 
> > 
> >>> x86: Don't silently override CONFIG_64BIT in 'make oldconfig'
> >>
> >> -tip testing found that this commit broke the UML build:
> >>
> >> /home/mingo/tip/arch/um/Makefile:52:
> >> /home/mingo/tip/arch/um/Makefile-x86: No such file or directory
> >> make[1]: *** No rule to make target
> >> `/home/mingo/tip/arch/um/Makefile-x86'.  Stop.
> >> make: *** [sub-make] Error 2
> > 
> > Hm, doesn't that mean that UML has always been broken for ARCH=x86?
> > 
> 
> Quite possible.  ARCH=x86 hasn't exactly been widely used.


what does ARCH=x86 mean?

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
