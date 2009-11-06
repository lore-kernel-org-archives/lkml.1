Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZKFJXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZKFJXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZKFJXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:23:39 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:38078 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZKFJXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:23:39 -0500
Date: Fri, 6 Nov 2009 10:23:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 07/11] sysctl: s390 Use the compat_sys_sysctl
Message-ID: <20091106102342.69b3ef7d@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1257468114-6823-7-git-send-email-ebiederm@xmission.com>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<1257468114-6823-7-git-send-email-ebiederm@xmission.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Nov 2009 16:41:50 -0800
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we have a generic 32bit compatibility implementation
> there is no need for s390 to implement it's own.
> 
> Cc: Carsten Otte <cotte@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/s390/kernel/compat_linux.c   |   53 -------------------------------------
>  arch/s390/kernel/compat_linux.h   |    2 -
>  arch/s390/kernel/compat_wrapper.S |    6 +---
>  3 files changed, 2 insertions(+), 59 deletions(-)

That looks nice, definitely an improvement over the old code.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

