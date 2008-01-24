Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbYAXWsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbYAXWsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYAXWsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:48:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYAXWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:48:22 -0500
Message-ID: <479915AA.9020604@redhat.com>
Date: Thu, 24 Jan 2008 16:48:10 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dann frazier <dannf@dannf.org>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4: fix memory corruption from misinterpreted	bad_inode_ops
 return values
References: <20080124061212.GA22079@ldl.fc.hp.com> <20080124195624.GJ8953@1wt.eu> <4798FDF2.3000605@redhat.com> <20080124223904.GA28495@colo.lackof.org>
In-Reply-To: <20080124223904.GA28495@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dann frazier wrote:

> Thanks Eric. Sounds like my comment about exercising these code paths
> wasn't too clear - the comments with your patch do make the issue
> clear, and this program demonstrates the void cast promotion issue
> well. I'm just not sure of a good way to demonstrate that my backport
> of this patch doesn't break anything for 2.4.

Ugh, no, that was my fault, I blindly copied & pasted something from a
bug which I thought was a testcase, but isn't.  Sorry!

I originally saw this problem on an fsfuzzed filesystem; I don't think I
still have that image around, though.

-Eric
