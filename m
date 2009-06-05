Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZFEWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZFEWGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZFEWGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:06:25 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35748 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZFEWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:06:25 -0400
Date: Sat, 6 Jun 2009 00:08:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] kbuild: fix a compile warning
Message-ID: <20090605220842.GI29008@uranus.ravnborg.org>
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 03:51:18AM -0400, Amerigo Wang wrote:
> 
> I got this warning:
> 
>  HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c: In function 'traps':
> scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
> scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules
> 
> Patch below fixes it.

We do not use -fno-strict-aliasing at userspace, so fix seems ok.
Applied.

	Sam
