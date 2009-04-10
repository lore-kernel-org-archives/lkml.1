Return-Path: <linux-kernel-owner+w=401wt.eu-S935346AbZDJD3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935346AbZDJD3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbZDJD2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:28:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:56606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762652AbZDJD2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:28:47 -0400
Subject: Re: [ANNOUNCE] headercheck - check dependencies on header files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090409204219.GA31511@uranus.ravnborg.org>
References: <20090409204219.GA31511@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 08:58:20 +0530
Message-Id: <1239334100.3036.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Thu, 2009-04-09 at 22:42 +0200, Sam Ravnborg wrote:
> We have at several occasions discussed if our header files
> should include their dependencies or not.
> 
> But we were lacking a tool to tell us if our header files
> included the headerfiles they needed or not.
> 
> headercheck can be used to do so.
> 
> headercheck use the existing Kbuild files in
> include/ to determine which directories to visit.
> 
> And for each directory it create one .c file for each
> .h file and build it.
> 
> A .c file looks like this:
> 
> 	$cat module.h.c
> 		#include <linux/module.h>
> 

Is it possible to check that which header files are included in source
file.

I mean how many header files are included for kernel/module.c and in
which order and we can also check that same file is requested how many
times, like:

	linux/module.h (requested count, included or not)
	+linux/list.h
	++linux/stddef.h

and so on.
		
Thanks,
--
JSR




