Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbXFVHQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbXFVHQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXFVHQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:16:32 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:13502 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXFVHQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:16:31 -0400
Message-ID: <467B7749.6050208@fr.ibm.com>
Date: Fri, 22 Jun 2007 09:16:25 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] namespace: ensure clone_flags are always stored in an
 unsigned long
References: <m13b0kebar.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b0kebar.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> While working on unshare support for the network namespace I noticed
> we were putting clone flags in an int.  Which is weird because the
> syscall uses unsigned long and we at least need an unsigned to
> properly hold all of the unshare flags. 
> 
> So to make the code consistent, this patch updates the code to use
> unsigned long instead of int for the clone flags in those places
> where we get it wrong today.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

we definitely want to do that. I have a similar patch waiting for 
next -mm doing the same.

Acked-by : Cedric Le Goater <clg@fr.ibm.com>

C.
