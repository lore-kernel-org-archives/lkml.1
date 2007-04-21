Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXDUH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXDUH47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXDUH46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:56:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030258AbXDUH4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:46 -0400
Date: Sat, 21 Apr 2007 00:55:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
Message-Id: <20070421005513.e230aa88.akpm@linux-foundation.org>
In-Reply-To: <20070420102652.075606533@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Define a new fs flag FS_SAFE, which denotes, that unprivileged
> mounting of this filesystem may not constitute a security problem.
> 
> Since most filesystems haven't been designed with unprivileged
> mounting in mind, a thorough audit is needed before setting this flag.

Practically speaking, is there any realistic likelihood that any filesystem
apart from FUSE will ever use this?

