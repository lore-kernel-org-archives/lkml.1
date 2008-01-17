Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbYAQWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbYAQWXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYAQWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:23:29 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52523 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbYAQWX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:23:28 -0500
Date: Thu, 17 Jan 2008 16:21:35 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Joseph Fannin <jfannin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.24-rc8-mm1 - mkubootimg wants <zlib.h>
Message-ID: <20080117162135.7291f273@zod.rchland.ibm.com>
In-Reply-To: <20080117212959.GA26254@nineveh.local>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080117212959.GA26254@nineveh.local>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 16:29:59 -0500
Joseph Fannin <jfannin@gmail.com> wrote:

> On Thu, Jan 17, 2008 at 02:35:14AM -0800, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> >  git-kbuild.patch
> 
> The "kbuild: rework arch specific Makefiles to use mkubootimg"
> changeset in Kbuild git introduces a kernel build dependency on the
> system zlib.h headers; scripts/mkubootimg/crc32.c wants it.
> 
> The build errors out if those headers aren't installed.  Was this
> intentional?

No, it wasn't.  The first patch in that series should have included the
zlib.h header itself as well.

Sam, I'll respin the first patch and send it to you shortly.  Sorry for
the trouble.

josh
