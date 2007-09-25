Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXIYXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXIYXN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXIYXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:13:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51365 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXIYXNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:13:48 -0400
Subject: Re: [patch] fix sys_mknodat breakage from r/o bind mounts
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IaJMd-000535-00@dorka.pomaz.szeredi.hu>
References: <E1IaJMd-000535-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 16:13:45 -0700
Message-Id: <1190762025.26982.315.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 00:58 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> mknod("foo", 0644) returns EINVAL, even though it should succeed.

Just to clarify, this is for when we use mknod to create normal,
non-device files, right?  Your fix looks very correct to me.

I'm curious, do you have a normal program that uses mknod(2) this way?
I'd like to add it to my test scripts.

Acked-by: Dave Hansen <haveblue@us.ibm.com>

-- Dave

