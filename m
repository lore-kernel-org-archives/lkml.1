Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYCRFGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYCRFGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYCRFFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:05:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYCRFFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:05:53 -0400
Date: Mon, 17 Mar 2008 22:05:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 2/8] mm: Add NR_WRITEBACK_TEMP counter
Message-Id: <20080317220514.c8856422.akpm@linux-foundation.org>
In-Reply-To: <20080317191942.482475908@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	<20080317191942.482475908@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 20:19:10 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> @@ -179,6 +179,7 @@ static int meminfo_read_proc(char *page,
>  		"PageTables:   %8lu kB\n"
>  		"NFS_Unstable: %8lu kB\n"
>  		"Bounce:       %8lu kB\n"
> +		"WritebackTmp: %8lu kB\n"

These fields are documented in Documentation/filesystems/proc.txt (please),
although we're missing some of them now.
