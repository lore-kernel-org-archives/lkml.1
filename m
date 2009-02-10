Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZBJWf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZBJWf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZBJWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:35:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086AbZBJWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:35:18 -0500
Date: Tue, 10 Feb 2009 14:34:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, jmorris@namei.org,
       safford@watson.ibm.com, serue@us.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH] integrity: shmem zero fix
Message-Id: <20090210143445.40b2cc9d.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0902091603mbab4d50id9790658c5579c15@mail.gmail.com>
References: <1234220548-4791-1-git-send-email-zohar@linux.vnet.ibm.com>
	<8bd0f97a0902091603mbab4d50id9790658c5579c15@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 19:03:51 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Mon, Feb 9, 2009 at 18:02, Mimi Zohar wrote:
> > Based on comments from Mike Frysinger and Randy Dunlap,
> > - moved ima.h include before CONFIG_SHMEM test
> > - added 'struct linux_binprm' in ima.h
> 
> please move the linux/fs.h include in linux/ima.h to match
> linux_binprm location while you're at it

Please write a full changelog too.  That one didn't tell us what
was being fixed.

As it is presumably a compilation fix, please include the compiler
error messages in the changelog, along with a description of what
circumstances cause the error to occur.

Thanks.
