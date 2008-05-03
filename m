Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYECVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYECVSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYECVSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:18:08 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64212 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbYECVSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:18:07 -0400
Date: Sat, 3 May 2008 22:17:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <481CC5CD.8060205@zytor.com>
Message-ID: <Pine.LNX.4.55.0805032209480.20206@cliff.in.clinika.pl>
References: <1209810775.6972.37.camel@localhost>
 <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
 <481CA40A.7040906@zytor.com> <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
 <481CC5CD.8060205@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, H. Peter Anvin wrote:

> It has retroactively been added to the documented list for all P6 core 
> chips - that should mean it works on all of them.  The most common 
> reason for not documenting something (other than various Pure Evil NDA 
> schemes) is that it hasn't been properly verified.  However, 
> verification can be done a posteori.

 True, but people do make mistakes from time to time. :)  If I had a
choice between a piece of silicon and a piece of documentation to trust, I
would choose the former.

 Obviously this specific case has turned out to be an issue with Qemu, so
it is somewhat irrelevant and given how the opcodes were added to the
architecture I would consider the emulator excused.

  Maciej
