Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbYASEpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbYASEpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762050AbYASEpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:45:14 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3145 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761257AbYASEpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:45:13 -0500
Date: Sat, 19 Jan 2008 05:44:50 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jan Beulich <jbeulich@novell.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       david-b@pacbell.net, linux-kernel@vger.kernel.org
Subject: Re: non-choice related config entries within choice
In-Reply-To: <20080116115233.GA26776@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801190538510.17507@scrub.home>
References: <478DF61E.76E4.0078.0@novell.com> <20080116115233.GA26776@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 Jan 2008, Sam Ravnborg wrote:

> But one feature I really would like to see is named chocies so we can do stuff like:
> 
> choice X86_PROCESSOR
> 
> config GENERIC_PROCESSOR
> 	bool "A generic X86 processor"
> endchoice
> 
> 
> ...
> 
> choice PPC_PROCESSOR
> 
> config GENERIC_PROCESSOR
> 	bool "A generic PowerPC processor
> 
> endchoice
> 
> The issue here is that we do not today allow the same config option
> to appear if more than one choice.

What I have in mind is slightly different, above choices would simply be 
called PROCESSOR, which would tell kconfig that all choices belong to the 
same group.

bye, Roman
