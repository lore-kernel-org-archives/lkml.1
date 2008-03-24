Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYCXXjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYCXXjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYCXXjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:39:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33086 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbYCXXjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:39:23 -0400
Date: Tue, 25 Mar 2008 02:38:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pavel@ucw.cz, ebiederm@xmission.com, xemul@openvz.org, sds@tycho.nsa.gov,
       roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324233850.GA213@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru> <20080324230930.GE2426@elf.ucw.cz> <20080324231859.GA193@tv-sign.ru> <20080324162659.89deedad.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324162659.89deedad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Andrew Morton wrote:
>
> On Tue, 25 Mar 2008 02:18:59 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > Please look at another discussion, http://marc.info/?t=120568298600007
> 
> -EAMTOOLAZY.  Whatever is at the above link should be in the changelog so we
> can understand the reasons for the patch!

No, no, this has nothing to do with this patch.

This was another patch, "don't panic if /sbin/init exits or killed", which
changed the current behaviour of /sbin/init unconditionally. And while I
thought this change is "obviously good" it wasn't, because we have users
which relies on the current behaviour.

Oleg.

