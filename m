Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXB1Shb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXB1Shb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXB1Shb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:37:31 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:46845 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbXB1Shb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:37:31 -0500
Date: Wed, 28 Feb 2007 10:33:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
Message-Id: <20070228103309.84a3a9e4.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702281022380.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
	<Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
	<Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
	<Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702281022380.12485@woody.linux-foundation.org>
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

On Wed, 28 Feb 2007 10:28:10 -0800 (PST) Linus Torvalds wrote:

> 
> 
> On Wed, 28 Feb 2007, Linus Torvalds wrote:
> > 
> > In other words, there is *zero* excuse for that braindamage.
> 
> To be clear:
> 
>  - in header files, we put "common definitions":
> 
> 	* #defines
> 	* data structure declarations
> 	* external function and data declarations
> 	* inline functions ("nicer but otherwise equivalent to a #define")
> 
>  - but we do *not* put
> 
> 	* actual real code
> 	* actual real data
> 
>    because those go into C files.
> 
> Yes, yes, all rules have exceptions, and sometimes we have ugly header 
> files. For an example of a pre-existing ugly header file that breaks these 
> rules, just look at <asm-i386/bugs.h> for example. Yeah, it only gets 
> included from one place, but it *still* shouldn't have code in it. It grew 
> over time, and none of the individual events were ever really big enough 
> for anybody to say "ok, we should clean this up and create a bugs.c file 
> in arch/i386/kernel".

It's on my TODO list... just not high priority.

> I'm sure there are other examples of the exceptions too. But I do not want 
> to add *new* ugly stuff, and I certainly refuse to do it after we're 
> already long past a merge window.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
