Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYAMXJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYAMXJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYAMXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:08:59 -0500
Received: from mx1.suse.de ([195.135.220.2]:58749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbYAMXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:08:58 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
Date: Mon, 14 Jan 2008 00:08:37 +0100
User-Agent: KMail/1.9.6
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080113203223.GA6723@cvg>
In-Reply-To: <20080113203223.GA6723@cvg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801140008.38188.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2008 21:32:23 Cyrill Gorcunov wrote:
> This patch converts ioctl call to unlocked_ioctl form with
> explicit big-kernel-lock. 

> Also it makes a bit of cleanup
> converting miscdevice structure initialization to C99 form.

First please always send cleanup patches separately. I think you have more
than just the C99 conversion.

Were you even able to compile it? Since ip27 is ia64 only that would need 
an IA64 cross compiler or a native ia64 machine.

It's probably better to focus on drivers only that actually build
on x86 :- see http://www.halobates.de/allyes for a compile log
showing all buildable files for x86-64 and i386.

Other than that the patch looks ok to me, but I haven't tried to 
compile it either.

-Andi
