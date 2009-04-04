Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZDDSDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZDDSDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZDDSCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:02:53 -0400
Received: from bu3sch.de ([62.75.166.246]:47689 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZDDSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:02:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sat, 4 Apr 2009 19:50:04 +0200
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <20090322211159.GA23042@electric-eye.fr.zoreil.com> <49CA1822.6050902@grupopie.com>
In-Reply-To: <49CA1822.6050902@grupopie.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904041950.04324.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 12:40:18 Rui Santos wrote:
> Francois Romieu wrote:
> > Can you see if one of the attached patches or a combination of them
> > makes a difference for the current (-git) kernel ?
> >   
> 
> I've concluded the tests. Unfortunately, the problem still remains.
> However, with both, and only both patches applied, the connection speed
> was higher and took longer, a lot longer to reproduce the problem but,
> it did.

I'm currently testing 2.6.29.1 without any additional patches but
with the pci=nomsi boot option.

I didn't notice any hickups, yet. I'm running a stresstest on a GBit link for quite
some time now. Earlier tests with older kernels and MSI burped earlier.

I will do more testing. If it turns out this is stable I will test the same kernel
with Message Signaled Interrupts to see if that causes some breakage.

-- 
Greetings, Michael.
