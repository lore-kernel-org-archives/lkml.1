Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbXJWUVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbXJWUVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXJWUUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:20:55 -0400
Received: from waste.org ([66.93.16.53]:42989 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbXJWUUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:20:54 -0400
Date: Tue, 23 Oct 2007 15:20:39 -0500
From: Matt Mackall <mpm@selenic.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] what the hell is going on with /proc/self?
Message-ID: <20071023202039.GK17536@waste.org>
References: <20071023020336.GC8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023020336.GC8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 03:03:36AM +0100, Al Viro wrote:
> 	What is the proc_base_stuff[] nonsense about?  AFAICS, that
> went in with no reason whatsoever in
> commit 801199ce805a2412bbcd9bfe213092ec656013dd
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Mon Oct 2 02:18:48 2006 -0700
> 
> 	Rationale is very weak and patch adds considerable complexity
> for no good reason.  Besides, it's obfuscated just for the hell of it:
> 	if (!IS_ERR(result) || PTR_ERR(result) != -ENOENT)
> instead of
> 	if (result != ERR_PTR(-ENOENT))
> etc.
> 
> 	Unless there are _real_ plans that would justify that animal,
> I'm going to get rid of it in the pending patch series (/proc/self
> cleanups, saner dentry retention for non-process parts, etc.).

Seems obvious to cc: Eric.

-- 
Mathematics is the supreme nostalgia of our time.
