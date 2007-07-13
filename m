Return-Path: <linux-kernel-owner+w=401wt.eu-S936920AbXGMP3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936920AbXGMP3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936840AbXGMP26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:28:58 -0400
Received: from [212.12.190.103] ([212.12.190.103]:32932 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S936177AbXGMP25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:28:57 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Fri, 13 Jul 2007 18:28:54 +0300
User-Agent: KMail/1.5
References: <200707130808.31109.a1426z@gawab.com>
In-Reply-To: <200707130808.31109.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707131828.54094.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> We have quite an efficient restoration code in the kernel right now.  It's
> able to upload big images (something like total RAM minus the size of the
> boot kernel, initrd and, optionally, the resume application), which is
> much more than we're able to save. :-)
>
> It can work with images uploaded via /dev/snapshot from the user space
> (specific image format is required, but that can be changed easily).

Then all that is need is to dump /dev/oldmem under the hibernate kernel and 
then feed it into /dev/snapshot when booting the normal kernel.

Or is there more to it?


Thanks!

--
Al

