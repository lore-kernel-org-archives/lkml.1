Return-Path: <linux-kernel-owner+w=401wt.eu-S965836AbXCVI2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965836AbXCVI2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXCVI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:28:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34959 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965836AbXCVI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:28:48 -0400
Date: Thu, 22 Mar 2007 08:28:15 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with fix-rmmod-read-write-races-in-proc-entries.patch in 2.6.21-rc4-mm1
Message-ID: <20070322082815.GV4095@ftp.linux.org.uk>
References: <20070322091445.0eecd44f.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322091445.0eecd44f.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 09:14:45AM +0100, Eric Dumazet wrote:
> Also, do we really need to proxy via proc_reg_file_ops files that are not provided by a module ?
> 
> I think not.
> 
> Could you please add in proc_get_inode() a check against de->proc_fops->owner ?

Let's _not_.  Bugs that depend on whether driver is built modular are
hell to deal with.
