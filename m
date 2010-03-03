Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0CCBXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:23:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:59950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab0CCBXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:23:42 -0500
Message-ID: <4B8DBCB8.7090706@kernel.org>
Date: Wed, 03 Mar 2010 10:34:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 42/62] sysfs: Remove sysfs_get/put_active_two
References: <20100302230933.GA32287@kroah.com> <1267572541-410-42-git-send-email-gregkh@suse.de>
In-Reply-To: <1267572541-410-42-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 01:23:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 03/03/2010 08:28 AM, Greg Kroah-Hartman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> It turns out that holding an active reference on a directory is
> pointless.  The purpose of the active references are to allows us to
> block when removing sysfs entries that have custom methods so we don't
> remove modules while running modular code and to keep those custom
> methods from accessing data structures after the files have been
> removed.

It's not only the method code but dynamic data structures or even the
actual hardware.

> Further sysfs_remove_dir remove all elements in the
> directory before removing the directory itself, so there is no chance
> we will remove a directory with active children.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Sans the patch description, Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
