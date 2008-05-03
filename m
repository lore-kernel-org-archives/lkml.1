Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYECVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYECVqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYECVqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:46:15 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:38916 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYECVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=VNve6YhEg1ryHJXoP2GSBgO4DvoiyxdZx9joDovvE/IpuDCpRMToVl11I4DHrXzeYDLHTVhKRfZDjC+y583WqAHBC7vOEGJbAkjBfKPqnhQopJqYom+uQhnkPakTJFd+VTfkJg0wCGP3/D6eUJTqJ4oIMHle/BtGwOUjwMLztOk=
Subject: Re: i387/FPU init issues...
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
In-Reply-To: <Pine.LNX.4.55.0805032209480.20206@cliff.in.clinika.pl>
References: <1209810775.6972.37.camel@localhost>
	 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
	 <481CA40A.7040906@zytor.com>
	 <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
	 <481CC5CD.8060205@zytor.com>
	 <Pine.LNX.4.55.0805032209480.20206@cliff.in.clinika.pl>
Content-Type: text/plain
Date: Sat, 03 May 2008 17:46:10 -0400
Message-Id: <1209851170.6972.64.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-05 at 22:17 +0100, Maciej W. Rozycki wrote:

>  True, but people do make mistakes from time to time. :)  If I had a
> choice between a piece of silicon and a piece of documentation to trust, I
> would choose the former.
> 
>  Obviously this specific case has turned out to be an issue with Qemu, so
> it is somewhat irrelevant and given how the opcodes were added to the
> architecture I would consider the emulator excused.

Sorry folks - had to run some errands. Wow, thanks for all the
responses.

Yes, the posting i just did (as pointed in my first email) was on
qemu (so was the /proc/cpuinfo). I moved to qemu because it was less
painful to do the git bisecting on my laptop; i used the same .config.
I should also note that qemu seems to have worked fine in the past.
In any case I will try to rerun on the older hardware which i can access
next week again. I am begining to doubt myself if it is the same issue;
i know even there it was pointing to FPU.
So is the correct fix then to go patch qemu then? I should point i am
running a slightly older version of qemu that has a few patches (nothing
to do with x86 emulation).

hpa, results from running on qemu (not the hardware) are:
-----
mambo:~# ./hpa
Test 0: ok
Test 1: ok
Test 2: ok
Test 3: err
Test 4: err
Test 5: err
Test 6: err
Test 7: err
Test 8: err
----------------

cheers,
jamal

