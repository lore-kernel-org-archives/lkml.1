Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZIDFip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZIDFip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZIDFio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:38:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256AbZIDFio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:38:44 -0400
Date: Thu, 3 Sep 2009 22:38:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [RFC Patch] kbuild: implement "make foo.s_c"
Message-Id: <20090903223809.7e303e6c.akpm@linux-foundation.org>
In-Reply-To: <20090904053233.4396.85814.sendpatchset@localhost.localdomain>
References: <20090904053233.4396.85814.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 01:30:06 -0400 Amerigo Wang <amwang@redhat.com> wrote:

> This patch implements "make path/to/file.s_c", where
> "file.s_c" is a file contains both asm and C code, this
> is helpful for people to do debugging at asm level.

Try

	make path/to/file.lst

:)
