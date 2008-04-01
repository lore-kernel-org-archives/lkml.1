Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbYDAVJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbYDAVJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761042AbYDAVHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37954 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761029AbYDAVHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:43 -0400
Date: Tue, 1 Apr 2008 17:07:42 -0400
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: regression: am-utils stopped working in 2.6.25-rc*
Message-ID: <20080401210742.GE21343@fieldses.org>
References: <Pine.SOC.4.64.0803281447530.6128@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0803281447530.6128@math.ut.ee>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 03:20:18PM +0200, Meelis Roos wrote:
> Current 2.6.25-rc* kernels have broken am-utils (NFS-based automounter) 
> support. No error messages, just "no such file or directory" when trying 
> to enter /net/anotherhostname. Just tried 2.6.24 and that worked fine. 
> am-utils is the latest in Debian unstable, 6.1.5-9.
> 
> Earliest 2.6.25-rc currently tested was 2.6.25-rc3+git as of 20080304. 
> This version reports 
> Invalid hostname "pid3477@koiott:/net" in NFS lock request
> into dmesg and am-utils does not work.
> 
> 2.6.25-rc4+git as of 20080310 and later ones do not show this message 
> but am-utils does still not work.
> 
> Will try bisecting it further.

Have you figured out anything more?  Can strace show exactly which
system call is  failing?

--b.
