Return-Path: <linux-kernel-owner+w=401wt.eu-S1759083AbZKGCSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083AbZKGCSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZKGCSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:18:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:42905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbZKGCSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:18:41 -0500
Message-ID: <4AF4D8FB.7060402@kernel.org>
Date: Sat, 07 Nov 2009 11:18:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 14/13] sysfs: sysfs_setattr remove unnecessary permission
 check.
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <m1ljim1op9.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljim1op9.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> inode_change_ok already clears the SGID bit when necessary so there is
> no reason for sysfs_setattr to carry code to do the same, and it is
> good to kill the extra copy because when I moved the code, I goofed
> and in certain corner cases the code will look at the wrong gid.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Tejun Heo <tj@kernel.org>

I would much prefer this one being prior to 06 but if it's too
painful, please at least note it in the description of 06.

Thanks.

-- 
tejun
