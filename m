Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZGBCRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZGBCRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZGBCRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:17:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58793 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbZGBCRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:17:07 -0400
Message-ID: <4A4C18D5.7020806@cn.fujitsu.com>
Date: Thu, 02 Jul 2009 10:17:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
In-Reply-To: <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Thanks Li - but as I said to Serge in the email when I brought this up
> originally, I already had a patch in mind for this; I've had an intern
> (Ben) at Google working on it. His patch (pretty much ready, and being
> sent out tomorrow I hope) is pretty similar to yours, but his is on
> top of another patch that provides a (currently read-only)
> "cgroup.procs" file in each cgroup dir that lists the unique tgids in
> the cgroup. So the key in the list of pid arrays is actually a pid_ns
> and a file type (indicating procs or tasks) rather than just a pid_ns.
> 
> So I think it makes more sense to not use this patch, but to use the
> pair of patches that Ben's written, since they provide more overal
> functionality.
> 

But I guess we are going to fix the bug for 2.6.31? So is it ok to
merge a new feature 'cgroup.procs' together into 2.6.31?


