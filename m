Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZIVPRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZIVPRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbZIVPRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:17:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41885 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbZIVPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:17:48 -0400
Date: Tue, 22 Sep 2009 16:17:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
Message-ID: <20090922151751.GM5858@ZenIV.linux.org.uk>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.447753909@nick.local0.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904065534.447753909@nick.local0.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 04:51:45PM +1000, npiggin@suse.de wrote:
> Use a brlock for the vfsmount lock.

I like it, but I'd like to see how costly it becomes on heavily SMP boxen.
Creation/removal of bindings as load...
