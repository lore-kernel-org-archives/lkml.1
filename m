Return-Path: <linux-kernel-owner+w=401wt.eu-S938493AbZDJMmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938493AbZDJMmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938326AbZDJMj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:39:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938283AbZDJMj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:39:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Fri, 10 Apr 2009 14:39:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904101439.43480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Linus Torvalds wrote:
> 
> On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
> > 
> > I'm seeing two problems with -git from today.
> 
> When today? A number of people apparently had module problems before 
> commit 97c18e2c7a8e36d2d83d50ee070314aadac73a11 ("module: 
> try_then_request_module must wait").
> 
> If you don't have that one, then that might explain both problems, in that 
> a "second try" would work for modules (your sound issue), and that 
> compiling things in would obviously avoid it (your storage driver thing).
> 
> But if you _do_ have that, then it's obviously something else ;)

Well, I do have that one. :-)

Rafael
