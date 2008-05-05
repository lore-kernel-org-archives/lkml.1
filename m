Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYEELQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYEELQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYEELQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:16:09 -0400
Received: from smtp5-g19.free.fr ([212.27.42.35]:35595 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbYEELQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 07:16:09 -0400
Date: Mon, 5 May 2008 13:16:07 +0200
From: FD Cami <francois.cami@free.fr>
To: "Kevin Burton" <burton@tailrank.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
Message-ID: <20080505131607.5556b1f2@olorin>
In-Reply-To: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, 5 May 2008 00:12:56 -0700
"Kevin Burton" <burton@tailrank.com> wrote:

> In the mean time is it possible to disable the page cache or limit it
> to say 10% of system memory?

You might want to look at /proc/sys/vm/ for tunables.
/proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
what you are looking for.
See this article for an explanation of swappiness :
http://www.leap-cf.org/oldarchive/2004-May/038622.html

> You could do this with RHEL 4.x but I don't recall this ever making it
> into 2.6 :-/

AFAIK RHEL 4.x runs 2.6.9.

Cheers

FDC
