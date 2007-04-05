Return-Path: <linux-kernel-owner+w=401wt.eu-S1767106AbXDEPkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767106AbXDEPkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767104AbXDEPkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:40:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20754 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767106AbXDEPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:40:07 -0400
Date: Thu, 5 Apr 2007 08:41:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk
Cc: lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
Message-Id: <20070405084155.e00687a4.randy.dunlap@oracle.com>
In-Reply-To: <20070404224152.29062e47.akpm@linux-foundation.org>
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
	<20070404224152.29062e47.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 22:41:52 -0700 Andrew Morton wrote:

> On Wed, 4 Apr 2007 22:05:34 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Use documented tag for "IA-32" (not "i386") to indicate which
> > kernel parameters apply to IA-32.
> 
> mv arch/i386 arch/ia32 ;)
> 
> Seriously, is there any point in this?  Kernel uses the i386 terminology
> and surely there's no confusion over what that represents.

Just that Documentation/kernel-parameters.txt explains what
"IA-32" means when it is used on kernel parameter descriptions:

	IA-32	IA-32 aka i386 architecture is enabled.

Our docs need some work.  No news there.

hpa wrote:
| We call this architecture "i386" everywhere else.  I think it makes more 
| sense to change the documented tag to "i386", especially with Intel 
| sometimes calling x86-64 "IA-32e".

Sounds reasonable.

Alan wrote:
| NAK. IA-32 is an Intel specific term, and I believe a protected mark at
| that.

OMG, quick, please send a patch for Documentation/kernel-parameters.txt.
(big ;)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
