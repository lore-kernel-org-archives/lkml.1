Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab0BYUYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:24:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0BYUYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:24:01 -0500
Date: Thu, 25 Feb 2010 15:23:58 -0500
From: Josef Bacik <josef@redhat.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Message-ID: <20100225202358.GC10960@localhost.localdomain>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
> Mounting btrfs corrupts memory and causes nasty crashes within a few
> seconds.  This seems to happen even if the mount fails (note the
> unrecognized mount option).  This is a regression from 2.6.32, and
> I've attached an example.
> 

And it only happens when you mount a btrfs fs?  Can you show me a trace of when
you mount a btrfs fs with valid mount options?  I'd like to see if we're not
cleaning up something properly or what.  Thanks,

Josef
