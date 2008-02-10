Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYBJRqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYBJRqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYBJRqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:46:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:12878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYBJRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=NwkFat9VlF5RbDzDWos6G0f86a310kJREfTRvJ68cqfBMIi3+OguV2mHyMBp+uuezvdZNOlep2zIrTpaMLETXwBarE5jc7Z1Ki50vtDi1fn01I594Le1EGD+gl/Q/PXqve0nWxg/SSsh4hi4awDg+FiKDw68L3tWExjHT8jwOfI=
Date: Sun, 10 Feb 2008 20:46:03 +0300
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Message-ID: <20080210174603.GB1754@martell.zuzino.mipt.ru>
References: <20080210140031.GA1754@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210140031.GA1754@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 05:00:31PM +0300,  wrote:
> This happened during LTP. FWIW, modprobe/rmmod trivial empty module
> together with cat /proc/*/wchan and cat /proc/modules were also running.
> 
> Box is E6400, much debugging is on, config below.
> 
> 
> [ 4057.310000] BUG: unable to handle kernel paging request at ffff810101dbc008
> [ 4057.310000] IP: [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
> [ 4057.310000] PGD 8063 PUD c063 PMD 153baa163 PTE 8000000101dbc160
> [ 4057.310000] Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> [ 4057.310000] CPU 0 
> [ 4057.310000] Modules linked in: [last unloaded: foo]
> [ 4057.310000] Pid: 7035, comm: ftest03 Not tainted 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #2
> [ 4057.310000] RIP: 0010:[<ffffffff802596c8>]  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70

Reproducible, BTW. As in, leave LTP for a while, go to sauna, return,
watch the corpse.
