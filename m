Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXCRSx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXCRSx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbXCRSx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:53:29 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33877 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbXCRSx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:53:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Catalin Marinas" <catalin.marinas@gmail.com>
Subject: [PATCH 0/4] tty: small fixes and cleanups.
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
Date: Sun, 18 Mar 2007 12:52:24 -0600
In-Reply-To: <m1vegyjspz.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 18 Mar 2007 12:45:44 -0600")
Message-ID: <m1r6rmjsev.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew the following tty fixes turned up while I was reviewing the
code to see if I was fixing the pid leaks properly.  I don't think
they are critical so at this point so they are probably not 2.6.21
material.

The do appear to be changes worth making though.

Eric
