Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYAFVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYAFVQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYAFVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:16:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYAFVQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:16:36 -0500
Date: Sun, 6 Jan 2008 16:16:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: kexec@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kexec buffer error
Message-ID: <20080106211628.GB19601@redhat.com>
References: <20080104135418.9ae53103.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104135418.9ae53103.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 01:54:18PM -0800, Randy Dunlap wrote:
> Hi,
> 
> kexec of 2.6.24-rc6-git11 fails for me with:
> 
> Close of /boot/kernel-2.6.24-rc6-git11 failed: : buffer  error
> kexec load failed, error = 1
> 

So close() system call seems to be failing here. If kexec-tools version
is same then we should not have erred on fd number etc. Could be a kernel
issue. I have no idea though.....


Thanks
Vivek
