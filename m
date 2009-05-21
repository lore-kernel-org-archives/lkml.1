Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZEUFhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZEUFhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZEUFho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:37:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:38409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZEUFhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:37:43 -0400
Message-ID: <4A14E89E.7010600@kernel.org>
Date: Thu, 21 May 2009 14:37:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 03/20] sysfs: Remove now unnecessary error reporting suppression.
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 05:37:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we use sysfs_rename_link in the places we previously
> used sysfs_create_link_nowarn we can remove sysfs_create_link_nowarn
> and all it's supporting infrastructure.

I'm not entirely sure why implementing a rename helper means that we
don't need nowarn version anymore.  Nothing really changed or is it
that the nowarn version wasn't too necessary anyway?

Thanks.

-- 
tejun
