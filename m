Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXHJISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXHJISb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbXHJISU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:18:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10313 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbXHJISS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:18:18 -0400
Date: Fri, 10 Aug 2007 12:18:10 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch added to -mm tree
Message-ID: <20070810081810.GB6670@localhost.sw.ru>
References: <200708100141.l7A1ftnd029565@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708100141.l7A1ftnd029565@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1124,7 +1118,6 @@ static struct ctl_table fs_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> -		.ctl_name	= FS_NRFILE,
>  		.procname	= "file-nr",
>  		.data		= &files_stat,
>  		.maxlen		= 3*sizeof(int),

Why? It will work just fine through default sysctl(2) writeback.

