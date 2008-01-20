Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYATIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYATIXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 03:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYATIXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 03:23:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45862 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYATIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 03:23:21 -0500
To: hpa@zytor.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-reply-to: <4792DF11.7040403@zytor.com> (hpa@zytor.com)
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <4792DF11.7040403@zytor.com>
Message-Id: <E1JGVSG-0003mx-TS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 20 Jan 2008 09:23:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Miklos Szeredi wrote:
> > - for mount ID's use IDA (from the IDR library) instead of a 32bit
> >   counter, which could overflow
> 
> IDAs tend to get reused quickly, which can cause race conditions.  Any 
> reason not to just use a 64-bit counter?

They tend to become hard to parse/compare for humans after a while.
And all this is basically only for humans, so race conditions don't
really matter.  Also a changed mount with a reused ID is easily
identified by comparing the other fields.

Miklos
