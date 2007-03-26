Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXCZAWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXCZAWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbXCZAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:22:32 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:3600 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbXCZAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:22:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAI6uBkZKhRO4dGdsb2JhbACPYAE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] INPUT: Delete unused source file drivers/input/power.c.
Date: Sun, 25 Mar 2007 20:22:29 -0400
User-Agent: KMail/1.9.3
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703251624330.31635@CPE00045a9c397f-CM001225dbafb6> <20070325143938.22c3b26d.akpm@linux-foundation.org>
In-Reply-To: <20070325143938.22c3b26d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252022.29513.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 18:39, Andrew Morton wrote:
> On Sun, 25 Mar 2007 16:28:39 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> 
> > Delete the never-compiled source file drivers/input/power.c, and
> > remove its entry from the corresponding Makefile, as there is no
> > Kconfig file that refers to the config option INPUT_POWER.
> 
> Please cc the maintainer when he's this easy to find ;)
> 
> There are significant-looking patches against input.c in the git-input
> tree - if it's presently dead I suspect that it'll be coming back to
> life soon.
> 

Actually it is just me being anal and trying to keep even dead modules
compilable... I think it is time for power.c to go. Now that we have ACPI
using input layer to report buttons/lid I don't see it coming back.

-- 
Dmitry
