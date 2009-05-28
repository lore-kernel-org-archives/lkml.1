Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZE1XsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZE1XsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZE1XsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:48:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbZE1XsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:48:07 -0400
Date: Thu, 28 May 2009 16:47:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       borislav.petkov@amd.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-Id: <20090528164720.0af5752b.akpm@linux-foundation.org>
In-Reply-To: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 20:43:53 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> here are some minor fixlets which came up lately. I'm sending them
> separately as an offset from the rest of the patchset since nothing has
> changed there. For details, see
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next

My linux-next x86_64 allmodconfig fails to build drivers/edac/amd64_edac.o:

{standard input}: Assembler messages:
{standard input}:3026: Error: no such instruction: `popcnt %eax,%ecx'

