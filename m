Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXJWUmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXJWUmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXJWUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:42:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50882 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXJWUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:42:17 -0400
Date: Tue, 23 Oct 2007 21:42:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] what the hell is going on with /proc/self?
Message-ID: <20071023204215.GD8181@ftp.linux.org.uk>
References: <20071023020336.GC8181@ftp.linux.org.uk> <20071023202039.GK17536@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023202039.GK17536@waste.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 03:20:39PM -0500, Matt Mackall wrote:
> On Tue, Oct 23, 2007 at 03:03:36AM +0100, Al Viro wrote:
> > 	What is the proc_base_stuff[] nonsense about?  AFAICS, that
> > went in with no reason whatsoever in
> > commit 801199ce805a2412bbcd9bfe213092ec656013dd
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Mon Oct 2 02:18:48 2006 -0700
> > 
> > 	Rationale is very weak and patch adds considerable complexity
> > for no good reason.  Besides, it's obfuscated just for the hell of it:
> > 	if (!IS_ERR(result) || PTR_ERR(result) != -ENOENT)
> > instead of
> > 	if (result != ERR_PTR(-ENOENT))
> > etc.
> > 
> > 	Unless there are _real_ plans that would justify that animal,
> > I'm going to get rid of it in the pending patch series (/proc/self
> > cleanups, saner dentry retention for non-process parts, etc.).
> 
> Seems obvious to cc: Eric.

Doh...  Sorry, thought I'd done that.  Eric, my apologies.
