Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYDHIUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYDHIUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYDHIUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:20:03 -0400
Received: from sacred.ru ([62.205.161.221]:35990 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYDHIUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:20:03 -0400
Message-ID: <47FB283C.6050509@openvz.org>
Date: Tue, 08 Apr 2008 12:09:32 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH] fix SEM_UNDO with namespaces, take 2
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com> <47F8E824.6090600@colorfullife.com> <47F8F99D.1070701@colorfullife.com> <47F9CB64.8040009@openvz.org> <47FA53F1.1030509@colorfullife.com>
In-Reply-To: <47FA53F1.1030509@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 08 Apr 2008 11:45:58 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +			if ((current->nsproxy == NULL && new_nsproxy != NULL) ||
> +				(current->nsproxy != NULL && new_nsproxy == NULL) ||
> +				(current->nsproxy != NULL && new_nsproxy != NULL && current->nsproxy->ipc_ns != new_nsproxy->ipc_ns)) {

Is the if (unshare_flags & CLONE_NEWIPC) check not enough?

Thanks,
Pavel
