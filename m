Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZGWCfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZGWCfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZGWCfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:35:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37630 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGWCfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:35:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 11:33:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC v17][PATCH 10/60] c/r: make file_pos_read/write() public
Message-Id: <20090723113320.65f6746d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1248256822-23416-11-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
	<1248256822-23416-11-git-send-email-orenl@librato.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a nitpick.

On Wed, 22 Jul 2009 05:59:32 -0400
Oren Laadan <orenl@librato.com> wrote:

> These two are used in the next patch when calling vfs_read/write()

> +static inline loff_t file_pos_read(struct file *file)
> +{
> +	return file->f_pos;
> +}
> +
> +static inline void file_pos_write(struct file *file, loff_t pos)
> +{
> +	file->f_pos = pos;
> +}
> +

I'm not sure but how about renaming this to
	file_pos() 
	set_file_pos()
at moving this to global include file ?

Thanks,
-Kame

