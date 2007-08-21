Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXHUT0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXHUT0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXHUT0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:26:07 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56208 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbXHUT0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:26:05 -0400
Date: Tue, 21 Aug 2007 15:25:56 -0400
To: John Stoffel <john@stoffel.org>
Cc: Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070821192556.GB27995@fieldses.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18123.13314.43009.263383@stoffel.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 02:50:42PM -0400, John Stoffel wrote:
> Not in my experience.  We use NetApps as our backing NFS servers, so
> maybe my experience isn't totally relevant.  But with a mix of Linux
> and Solaris clients, we've never had problems with soft,intr on our
> NFS clients.
> 
> We also don't see file corruption, mysterious executables failing to
> run, etc.  
> 
> Now maybe those issues are raised when you have a Linux NFS server
> with Solaris clients.  But in my book, reliable NFS servers are key,
> and if they are reliable, 'soft,intr' works just fine.

The NFS server alone can't prevent the problems Peter Staubach refers
to.  Their frequency also depends on the network and the way you're
using the filesystem.  (A sufficiently paranoid application accessing
the filesystem could function correctly despite the problems caused by
soft mounts, but the degree of paranoia required probably isn't common.)

In practice, you may get away with soft mounts and never see problems.
But other people considering them should probably make sure they
understand the issues before trusting anything important to them.

--b.
