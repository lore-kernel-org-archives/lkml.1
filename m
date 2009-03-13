Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZCMSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZCMSWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZCMSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:22:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51251 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZCMSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:22:03 -0400
Subject: Re: [PATCH] eCryptfs: Don't encrypt file key with filename key
From: Dustin Kirkland <kirkland@canonical.com>
Reply-To: kirkland@canonical.com
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090313133916.GA32304@us.ibm.com>
References: <20090313062410.GA32384@boomer>
	 <20090313133916.GA32304@us.ibm.com>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 13 Mar 2009 13:21:50 -0500
Message-Id: <1236968511.4904.32.camel@t61p>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 08:39 -0500, Serge E. Hallyn wrote:
> Right, so the file name encryption key is the same for all the files,
> whereas you can have multiple file encryption key encryption keys.
> So this bug means that the ability to have multiple FEKEKs becomes
> completely worthless.

True, but only for files created up until this point with eCryptfs
filename encryption enabled.

Considering 2.6.29 is in RC, and Ubuntu Jaunty is still in Alpha (which
is carrying a backport of eCryptfs against 2.6.28), this should be a
relatively controlled set of affected individuals who should be at least
somewhat aware that they're running pre-release code.

+1, ACK on Tyler's patch.  It's a good, simple fix.  We're going to
carry that against Ubuntu's kernel.  I certainly hope that it will make
it into 2.6.29 which should land on a lot more systems.

> This makes me wonder if it's not worth doing a complete code-vs-design
> comparison to make sure there are no other such gems hidden away.

Definitely a good idea.

> Tyler, do you have a user-space (hopefully easier-to-read) parser for
> encrypted ecryptfs files?  (ISTR they were closely following a gpg
> format)

I'll take the to-do to fix this in userspace.  I've file a bug for my
own tracking purposes.  I'll update this as I enhance the ecryptfs-stat
utility:
 * https://bugs.launchpad.net/ecryptfs/+bug/342398

-- 
:-Dustin

Dustin Kirkland
Ubuntu Server Developer
Canonical, LTD
kirkland@canonical.com
GPG: 1024D/83A61194

