Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZFMNrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZFMNrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZFMNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:47:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47497 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbZFMNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:47:29 -0400
Date: Sat, 13 Jun 2009 15:49:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: references to non-existent header files under include/linux
Message-ID: <20090613134947.GA30053@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0906130932570.16165@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906130932570.16165@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 09:35:42AM -0400, Robert P. J. Day wrote:
> 
>   again, since this output is fairly short, this is a list of
> references throughout the source tree of the form:
> 
>   #include <linux/whatever>
> 
> where there does not appear to be any such header file.  might be some
> false positives but i'm not going to agonize over it.
> 
> 
> === Missing: include/linux/bounds.h ===
> include/linux/mmzone.h:18:#include <linux/bounds.h>
> include/linux/page-flags.h:11:#include <linux/bounds.h>
bounds.h is generated.

> === Missing: include/linux/compile.h ===
> arch/x86/boot/version.c:17:#include <linux/compile.h>
> init/version.c:9:#include <linux/compile.h>
compile.h is generated.

The rest looks like real bugs.
Please submit patches to fix them up.

	Sam
