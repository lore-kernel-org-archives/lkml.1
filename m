Return-Path: <linux-kernel-owner+w=401wt.eu-S937005AbZDIXKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937005AbZDIXKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZDIXJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:09:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757203AbZDIXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:09:52 -0400
Date: Thu, 9 Apr 2009 16:06:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arjan van de Ven <arjan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but
 annoying) audio problem
In-Reply-To: <200904100057.43827.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain>
References: <200904100057.43827.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
> 
> I'm seeing two problems with -git from today.

When today? A number of people apparently had module problems before 
commit 97c18e2c7a8e36d2d83d50ee070314aadac73a11 ("module: 
try_then_request_module must wait").

If you don't have that one, then that might explain both problems, in that 
a "second try" would work for modules (your sound issue), and that 
compiling things in would obviously avoid it (your storage driver thing).

But if you _do_ have that, then it's obviously something else ;)

		Linus
