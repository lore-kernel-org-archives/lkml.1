Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYC1KWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYC1KWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYC1KWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:22:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYC1KWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:22:41 -0400
Date: Fri, 28 Mar 2008 03:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Message-Id: <20080328032139.7af69ff9.akpm@linux-foundation.org>
In-Reply-To: <12048053473401-git-send-email-giometti@linux.it>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Mar 2008 13:09:00 +0100 Rodolfo Giometti <giometti@linux.it> wrote:

> This patch adds the kernel side of the PPS support currently named
> "LinuxPPS".

powerpc:

drivers/pps/pps.c: In function 'pps_cdev_ioctl':
drivers/pps/pps.c:166: warning: format '%lld' expects type 'long long int', but argument 2 has type '__s64'
drivers/pps/kapi.c: In function 'pps_event':
drivers/pps/kapi.c:225: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__s64'
drivers/pps/sysfs.c: In function 'pps_show_assert':
drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
drivers/pps/sysfs.c: In function 'pps_show_clear':
drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
