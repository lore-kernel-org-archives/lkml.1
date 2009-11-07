Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbZKGC1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbZKGC1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZKGC1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:27:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:36054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZKGC1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:27:39 -0500
Message-ID: <4AF4DB15.6080409@kernel.org>
Date: Sat, 07 Nov 2009 11:27:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/13] sysfs: Update sysfs_setxattr so it updates secdata
 under the sysfs_mutex
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257249429-12384-1-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> The sysfs_mutex is required to ensure updates are and will remain
> atomic with respect to other inode iattr updates, that do not happen
> through the filesystem.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
