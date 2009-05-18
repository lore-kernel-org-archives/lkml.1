Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZERFCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZERFCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 01:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZERFCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 01:02:22 -0400
Received: from claw.goop.org ([74.207.240.146]:34698 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZERFCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 01:02:22 -0400
Message-ID: <4A10EBDD.7030304@goop.org>
Date: Sun, 17 May 2009 22:02:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>	<20090513133021.GA7277@elte.hu>	<4A0ADBA2.2020300@goop.org>	<20090515182757.GA19256@elte.hu>	<4A0DCC11.10307@goop.org>	<m1my9ex818.fsf@fess.ebiederm.org>	<4A0DFF78.6000501@goop.org>	<20090515202250.0f1218ef@jbarnes-g45>	<m1iqk1k708.fsf@fess.ebiederm.org> <20090516112233.5cb085c8@jbarnes-g45>
In-Reply-To: <20090516112233.5cb085c8@jbarnes-g45>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> This is really about what software Xen wants to support though.  You
> can say, "it would be easier for you to just support new software that
> doesn't use MTRRs," and you might be right, but supporting older stuff
> doesn't appear that difficult, and it sounds like something they want
> to do.
>   

My rough target is that you should be able to take a pvops-dom0 kernel 
and use it to replace the 2.6.18-xen (or other patched up -xen) kernel 
on an existing server installation without having to replace very much 
(or anything) else.  In practise that means making it work in something 
like RHEL 5 or SLES 10(?) environment.  That seems to be what at least 
some of my testers are doing.

Of course, most of the deployments will be with whatever new distro 
ships with the kernel.  But that doesn't mean we can write-off the old 
stuff.  (I think AKPM still tests current kernels on something like FC1 
or 2 to check for general kernel/distro regressions.)

    J
