Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYHUDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYHUDKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYHUDKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:10:03 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2438 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbYHUDKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:10:00 -0400
Date: Thu, 21 Aug 2008 05:09:44 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Mike Frysinger <vapier@gentoo.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/timex.h: cleanup for userspace
In-Reply-To: <1219200383-19556-1-git-send-email-vapier@gentoo.org>
Message-ID: <Pine.LNX.4.64.0808210507410.2507@localhost.localdomain>
References: <1219200383-19556-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 19 Aug 2008, Mike Frysinger wrote:

> MAXFREQ_SCALED was tweaked recently to contain a (s64) cast.  Assuming this
> is meant for userspace, change it to (__s64) and pull in linux/types.h.

No, it's irrelevant for user space.
Most of it can be moved down into the __KERNEL__ block.
Look at the glibc timex.h for what is currently exported.

bye, Roman
