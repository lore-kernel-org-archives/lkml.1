Return-Path: <linux-kernel-owner+w=401wt.eu-S1031696AbXEANGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031696AbXEANGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031694AbXEANGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:06:40 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:40944 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031689AbXEANGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:06:39 -0400
Subject: file capabilities and security_task_wait failure Re: 2.6.22 -mm
	merge plans
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>,
       linuxfs <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 01 May 2007 09:06:09 -0400
Message-Id: <1178024769.26421.26.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 16:20 -0700, Andrew Morton wrote:
>  implement-file-posix-capabilities.patch
>  file-capabilities-accomodate-future-64-bit-caps.patch
>  return-eperm-not-echild-on-security_task_wait-failure.patch
> 
> I think we're still waiting for the security guys to work out what to do with
> this work.

return-eperm-not-echild-on-security_task_wait-failure.patch should be
merged - it is effectively a bug fix.

On the file capabilities support, have any of the filesystem folks
(cc'd) looked at the code yet?

-- 
Stephen Smalley
National Security Agency

