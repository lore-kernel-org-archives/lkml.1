Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZCBSTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZCBSTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZCBSTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:19:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZCBSTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:19:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ipgRA4DFXw/tgDohdzBSiukh6GisWtXJmTrHe9yRuMFEux9WR7J4sVCjJ1VgPpbbv
	bHIgT8Ho4Mv4Cz20r/8qA==
MIME-Version: 1.0
In-Reply-To: <49AB40BF.4030706@cn.fujitsu.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
Date: Mon, 2 Mar 2009 10:19:15 -0800
Message-ID: <6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 1, 2009 at 6:13 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Now a cgroup subsystem can set default file mode of its control files,
> so here is a patchset to correct file mode of each subsystem's files.

I really think that we should be defaulting this based on whether the
control file has read or write handlers.

Sure, there are special cases like "tasks" that we'd need to set a
manual value for, but most of these patches would be unnecessary.

Paul

>
> Should be applied after:
>        cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch
>
> [PATCH 1/4] cgroup debug: show correct file mode
> [PATCH 2/4] cpuacct: show correct file mode
> [PATCH 3/4] devcgroup: show correct file mode
> [PATCH 4/4] cpuset: show correct file mode
>
>
