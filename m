Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0CCBZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 20:25:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:60011 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0CCBZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 20:25:08 -0500
Message-ID: <4B8DBD10.3030506@kernel.org>
Date: Wed, 03 Mar 2010 10:36:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 43/62] sysfs: Only take active references on attributes.
References: <20100302230933.GA32287@kroah.com> <1267572541-410-43-git-send-email-gregkh@suse.de>
In-Reply-To: <1267572541-410-43-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 01:25:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 08:28 AM, Greg Kroah-Hartman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> If we exclude directories and symlinks from the set of sysfs
> dirents where we need active references we are left with
> sysfs attributes (binary or not).
> 
> - Tweak sysfs_deactivate to only do something on attributes
> - Move lockdep initialization into sysfs_file_add_mode to
>   limit it to just attributes.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
