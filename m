Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZA0MtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZA0MtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZA0MtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:49:09 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:47064 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZA0MtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:49:09 -0500
Date: Tue, 27 Jan 2009 13:48:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127134854.1a9992fd@hyperion.delvare>
In-Reply-To: <s5h1vupcctf.wl%tiwai@suse.de>
References: <497EB491.6080904@numericable.fr>
	<s5hbpttcigu.wl%tiwai@suse.de>
	<20090127094628.670eca16@hyperion.delvare>
	<s5h1vupcctf.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Tue, 27 Jan 2009 10:34:20 +0100, Takashi Iwai wrote:
> At Tue, 27 Jan 2009 09:46:28 +0100,
> > On Tue, 27 Jan 2009 08:32:17 +0100, Takashi Iwai wrote:
> > > A bogus warning.  Ignore this.
> > 
> > No matter how bogus it is, it should be fixed. Otherwise this is
> > wasting the time of users and developers over and over again.
> 
> Well, it's a bug of gcc appearing only in a certain version, so most
> people won't see it.
> 
> Of course, we can put uninitialized_var().  But, I don't basically
> like adding it unconditionally... 

I didn't know about uninitialized_var(), thanks for the hint.

My experience with these warnings is that, in many cases, it is
possible to write the code differently so that it is clear to the
compiler that the variable is never used uninitialized. In some cases,
doing so also makes the code easier to read for humans and less likely
to break in the future.

Of course, in some cases the problem is simply that the compiler is too
stupid to understand even simple things, but in other cases these
warnings might be a good opportunity to rewrite the code in a way that
is easier to understand.

-- 
Jean Delvare
