Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZBRBcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZBRBcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZBRBb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:31:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbZBRBb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:31:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=igPLlmfgF4nvUiQNRzTkN6yKfWDrCctXEBn70JHeYt2ztx3+Hs1ky+kn2oj5L5fE3
	jPW4evY0RFpvGq+h1hUYQ==
MIME-Version: 1.0
In-Reply-To: <499B64DA.5070403@cn.fujitsu.com>
References: <499B64DA.5070403@cn.fujitsu.com>
Date: Tue, 17 Feb 2009 17:31:52 -0800
Message-ID: <6599ad830902171731m5bc41046r710255661defcf9f@mail.gmail.com>
Subject: Re: [PATCH] cgroups: update documentation about css_set hash table
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 5:31 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> The css_set hash table was introduced in 2.6.26, so update the documentation
> accordingly.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  Documentation/cgroups/cgroups.txt |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index d9e5d6f..93feb84 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -252,10 +252,8 @@ cgroup file system directories.
>  When a task is moved from one cgroup to another, it gets a new
>  css_set pointer - if there's an already existing css_set with the
>  desired collection of cgroups then that group is reused, else a new
> -css_set is allocated. Note that the current implementation uses a
> -linear search to locate an appropriate existing css_set, so isn't
> -very efficient. A future version will use a hash table for better
> -performance.
> +css_set is allocated. The appropriate existing css_set is located by
> +looking into a hash table.
>
>  To allow access from a cgroup to the css_sets (and hence tasks)
>  that comprise it, a set of cg_cgroup_link objects form a lattice;
> --
> 1.5.4.rc3
>
