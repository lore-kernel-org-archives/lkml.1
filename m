Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZB1Isk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZB1Isk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZB1Isc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:48:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbZB1Isc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:48:32 -0500
Date: Sat, 28 Feb 2009 00:47:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Eric Anholt <eric@anholt.net>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       airlied@linux.ie, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
Message-Id: <20090228004751.96d1ea8d.akpm@linux-foundation.org>
In-Reply-To: <49A8F660.10604@gmail.com>
References: <49A7B253.906@gmail.com>
	<20090227023231.76e7c65f.akpm@linux-foundation.org>
	<20090227130440.GA24633@silver.sucs.org>
	<49A7EF52.8080105@gmail.com>
	<20090227231207.GA4687@silver.sucs.org>
	<1235780431.6992.14.camel@gaiman>
	<49A8F660.10604@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 09:31:28 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 28.2.2009 01:20, Eric Anholt wrote:
> > KMS support is not a feature of the server but of your 2D driver.  You
> > want 2.6.2, or things will be bad.
> 
> I have 2.5.0. After turning KMS off, problem seems to be solved.
> 
> Anyway, I would appreciate a version of the intel driver being in the 
> Kconfig text, otherwise it looks like: don't use this on machines with 
> installation from stone age. If one has latest stable release of a 
> distro, he doesn't even think he doesn't have "new enough userspace".
> 
> For reference, the text is:
> Choose this option if you want kernel modesetting enabled by default,
> and you have a new enough userspace to support this. Running old
> userspaces with this enabled will cause pain.

Hang on.

The kernel deadlocked on struct_mutex, did it not?  That's a kernel bug
regardless of what userspace you're running.

Do we know why this happened?
