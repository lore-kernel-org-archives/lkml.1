Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYH1SU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYH1SU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYH1SUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53076 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbYH1SUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:15 -0400
To: tj@kernel.org
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <1219945263-21074-1-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Fri, 29 Aug 2008 02:40:56 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
Message-Id: <E1KYm6E-0003rI-RI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 20:20:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Tejun Heo wrote:
> This patchset extends FUSE such that it supports more file operations
> and is consisted of the following seven patches.
> 
>   0001-FUSE-add-include-protectors.patch
>   0002-FUSE-pass-nonblock-flag-to-client.patch
>   0003-FUSE-implement-nonseekable-open.patch
>   0004-FUSE-implement-direct-lseek-support.patch
>   0005-FUSE-implement-ioctl-support.patch
>   0006-FUSE-implement-unsolicited-notification.patch
>   0007-FUSE-implement-poll-support.patch
> 
> The added features will be used primarily for CUSE but can be used by
> any FUSE client.  Accompanying libfuse updates will be posted
> separately.

Guessing that CUSE stands for "Character Devices in Userspace"?

Is there a description of this?  It's for sound device emulation,
right?

What is direct-lseek for?  It doesn't sound like a feature needed by
char devices.

Thanks,
Miklos
