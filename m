Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYF3FMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYF3FMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 01:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYF3FMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 01:12:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYF3FMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 01:12:05 -0400
Message-ID: <48686AD3.1070300@kernel.org>
Date: Sun, 29 Jun 2008 22:10:43 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 0/39] Merge files at x86/lib
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
In-Reply-To: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Hey folks,
> 
> Here it goes a series of patch that merges some user-related files.
> From x86/lib, delay.c, getuser.S, and putuser.S are merged. For the
> last two of them, the accompanying include/asm-x86/uaccess.h is merged.
> Or close to. There are some small leftovers, that are sufficiently
> different to remain in its own files.
> 
> As for bisectability, all patches have been tested in more than 20
> different configs for both i386 and x86_64, in the usual way (just
> I'm testing in more configs now). If you find a build bug in this
> series, please send me the offending config so I can add to my poll.
> 
> The diffstat and the one-big-patch follows at the end of this introductory
> message.
> 
> Ingo, in the absence of any objections, you can pull this work from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> 
> into your tip/master tree
> 

Hi Glauber,

Applied to -tip as x86/unify-lib.

	-hpa
