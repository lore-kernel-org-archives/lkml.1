Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYH1SWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYH1SWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYH1SVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:21:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055AbYH1SVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:21:24 -0400
Message-ID: <48B6EC83.1070207@kernel.org>
Date: Thu, 28 Aug 2008 11:20:51 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org>
In-Reply-To: <1219945263-21074-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ioctl support is tricky to implement because only the ioctl
> implementation itself knows which memory regions need to be read
> and/or written.  To support this, fuse client can request retry of
> ioctl specifying memory regions to read and write.  Deep copying
> (nested pointers) can be implemented by retrying multiple times
> resolving one depth of dereference at a time.

Okay, I'm going to say it... wouldn't it be better to have some kind of 
data structure description language which the userspace can register 
with the kernel to linearize the data on a per-ioctl basis (kind of like 
rpcgen)?

	-hpa
