Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZEXDYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZEXDYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 23:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZEXDYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 23:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:45777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZEXDYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 23:24:34 -0400
Message-ID: <4A18BDDC.7060305@kernel.org>
Date: Sun, 24 May 2009 12:24:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs:  Only support removing emtpy sysfs directories.
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 03:24:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> I have looked and I have not found a single legitimate case today where
> we remove sysfs directories with anything in them.  The only case I have
> found to date was a bug.  It was a problem of ownership.  The files in
> the directory where not owned by the directory itself.   Leaving open
> the potential for double deletion of the directory contents.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

For 21-24: Acked-by: Tejun Heo <tj@kernel.org>

25 maybe can be folded into the eariler in the series?

Thanks.

-- 
tejun
