Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZKGCUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZKGCUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZKGCUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:20:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:42953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZKGCU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:20:29 -0500
Message-ID: <4AF4D968.3040608@kernel.org>
Date: Sat, 07 Nov 2009 11:20:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
References: <m13a4vbz8r.fsf@fess.ebiederm.org>	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>	<20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>	<4AF4D76C.6090008@kernel.org> <m1y6mjw03m.fsf@fess.ebiederm.org>
In-Reply-To: <m1y6mjw03m.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> NFS does exactly the same thing I am doing.

Oh... well, sysfs directories parenting other filesystems are pretty
rare and well defined.  Although it's not very pretty, I don't think
we'll see any actual problem there.  Thanks for the explanation.

-- 
tejun
