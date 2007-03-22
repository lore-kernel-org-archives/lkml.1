Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXCVSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXCVSlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbXCVSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:41:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282AbXCVSlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:41:20 -0400
Date: Thu, 22 Mar 2007 13:14:36 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix cpufreq_stats attrs removal
Message-ID: <20070322171436.GM15364@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
	Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20070319153013.GA6814@localhost.sw.ru> <20070319204125.GA5598@suse.de> <20070320100634.GA6811@localhost.sw.ru> <20070322030753.GB5728@suse.de> <20070322035104.GA17159@redhat.com> <20070322040006.GA6892@suse.de> <20070321201042.f1cbf4d8.akpm@linux-foundation.org> <20070322170201.GP4108@inferi.kami.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322170201.GP4108@inferi.kami.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 06:02:01PM +0100, Mattia Dongili wrote:

 > The problem is cpufreq_stats doesn't know when a cpufreq driver is
 > removed and doesn't cleanup. I guess this affects any setup with
 > cpufreq_stats.
 > The attached patch seems to solve both symptoms and yes... it's quite
 > invasive as it introduce one more cpufreq policy notification (REMOVED).
 > 
 > BTW: the patch is against .21-rc4-mm1 but applies with some fuzz to
 > 2.6.20 too

Alternatively, as it's just debug functionality, we could just
mark it unsafe for rmmod, which is nastier, but a lot less invasive
to the non-debug code.

	Dave

-- 
http://www.codemonkey.org.uk
