Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXC3Pjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXC3Pjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXC3Pjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:39:45 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:63746 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXC3Pjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:39:44 -0400
Date: Fri, 30 Mar 2007 07:39:37 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: perfmon@napali.hpl.hp.com, Stephane Eranian <eranian@hpl.hp.com>
Subject: exposing FSB clock speed in /sys
Message-ID: <20070330153937.GC16059@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It seems that the kernel does not expose the Front-Side Bus (FSN) Clock
speed to user applications. I found code in the kernel dealing with
frequency scaling that extracts the information for x86 processors but
the value is never exposed.

Knowledge the the FSB speed is very useful to monitoring tools. It is used
to compute certain bus-related metrics.

Looking at the code, it seems that there is no standard way of extracting
the FSB speed. For each processor model, you have different MSRs. I would
think that the routines in the cpufreq code could be moved out and used
as the basis to expose the information somewhere in /sys.

Any comments?

-- 
-Stephane
