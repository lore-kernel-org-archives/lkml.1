Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYKDGkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYKDGkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYKDGkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:40:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34545 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYKDGkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:40:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=F0tbsL2iL9IgR/siwkQzsXRDv2BromnrDvya7UHTbKu5B0MkZUIyncTkVnu/8DZlk
	67G/M0aXJegJt2vRJxgug==
MIME-Version: 1.0
In-Reply-To: <490FE7B5.8020400@cn.fujitsu.com>
References: <20080811235323.872291138@us.ibm.com>
	 <20080811235325.121356317@us.ibm.com>
	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
	 <490FE7B5.8020400@cn.fujitsu.com>
Date: Mon, 3 Nov 2008 22:40:03 -0800
Message-ID: <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
Subject: Re: [PATCH 3/5] Container Freezer: Implement freezer cgroup subsystem
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 10:12 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> I think another reasonable and easier way is to disable writing freezer.state
> of top cgroup, so we can skip checks in freezer_fork() for tasks in top cgroup.
>

Yes, if freezing the root cgroup isn't needed then that is definitely
simpler - I wasn't sure if Matt wanted to be able to freeze the root
group with this subsystem.

Paul
