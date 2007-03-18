Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXCSJ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXCSJ5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbXCSJ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:57:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47181 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774AbXCSJ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:57:47 -0400
Date: Sun, 18 Mar 2007 20:55:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 3/4] tty: Introduce no_tty and use it in selinux
Message-ID: <20070318205523.39473bd0@lxorguk.ukuu.org.uk>
In-Reply-To: <m1bqiqjrnx.fsf_-_@ebiederm.dsl.xmission.com>
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	<m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	<m1slc4luf5.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703161544h2961670dh8f5e499fd2dc0ce5@mail.gmail.com>
	<m1vegyjspz.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6rmjsev.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz2ajs6g.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy82jrwz.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqiqjrnx.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 13:08:34 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> While researching the tty layer pid leaks I found a weird case in
> selinux when we drop a controlling tty because of inadequate
> permissions we don't do the normal hangup processing.  Which is a
> problem if it happens the session  leader has exec'd something that
> can no longer access the tty.

Acked-by: Alan Cox <alan@redhat.com>
