Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXJZHiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXJZHiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbXJZHhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:37:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49465 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbXJZHhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:37:54 -0400
Date: Fri, 26 Oct 2007 08:37:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 19/45] Add struct vfsmount parameters to vfs_rename()
Message-ID: <20071026073749.GE8181@ftp.linux.org.uk>
References: <20071026064024.243943043@suse.de> <20071026064049.534093497@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026064049.534093497@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 11:40:43PM -0700, jjohansen@suse.de wrote:
> The vfsmount will be passed down to the LSM hook so that LSMs can compute
> pathnames.

You know, you really are supposed to understand the code you are modifying...
Quiz: what are those vfsmounts and how are they related?

Al, carefully abstaining from saying what he really thinks of LSM and its
users...
