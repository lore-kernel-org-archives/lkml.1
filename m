Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYH1U4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYH1U4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYH1U4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:56:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36914 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbYH1U4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:56:16 -0400
To: hpa@kernel.org
CC: miklos@szeredi.hu, tj@kernel.org, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <48B708C4.4000405@kernel.org> (hpa@kernel.org)
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org> <48B6F7C5.3020204@kernel.org> <E1KYn0U-00047F-Qa@pomaz-ex.szeredi.hu> <48B708C4.4000405@kernel.org>
Message-Id: <E1KYoX9-0004Mn-NX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 28 Aug 2008 22:55:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, H. Peter Anvin wrote:
> This is *hard* to get right, and we screw this up in the kernel with 
> painful regularity.  The throught of having user-space processes, which 
> don't have access to the kernel locking primitives and functions like 
> copy_from_user() dealing with this stuff scares me crazy.

What issues exactly are you thinking of?

> That is why I'm suggesting using an in-kernel linearizer.

Lots of complexity, ugh...  Even Tejun's current scheme is better IMO.

Miklos

