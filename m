Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYAYF0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYAYF0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYAYF0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:26:01 -0500
Received: from 1wt.eu ([62.212.114.60]:1603 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYAYF0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:26:00 -0500
Date: Fri, 25 Jan 2008 05:53:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dann frazier <dannf@dannf.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4: fix memory corruption from misinterpreted	bad_inode_ops return values
Message-ID: <20080125045320.GA24179@1wt.eu>
References: <20080124061212.GA22079@ldl.fc.hp.com> <20080124195624.GJ8953@1wt.eu> <4798FDF2.3000605@redhat.com> <20080124223904.GA28495@colo.lackof.org> <479915AA.9020604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479915AA.9020604@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 04:48:10PM -0600, Eric Sandeen wrote:
> dann frazier wrote:
> 
> > Thanks Eric. Sounds like my comment about exercising these code paths
> > wasn't too clear - the comments with your patch do make the issue
> > clear, and this program demonstrates the void cast promotion issue
> > well. I'm just not sure of a good way to demonstrate that my backport
> > of this patch doesn't break anything for 2.4.
> 
> Ugh, no, that was my fault, I blindly copied & pasted something from a
> bug which I thought was a testcase, but isn't.  Sorry!
> 
> I originally saw this problem on an fsfuzzed filesystem; I don't think I
> still have that image around, though.

OK, that doesn't matter that much. At least the patch makes sense and
your example shows why original code is wrong, so I will merge it. If
anybody had a problem with it, the code would be easily bisectable
(there are so few patches in 2.4) and it's easy to revert it.

Thanks to you both, Eric and Dann !
Willy

