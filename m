Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYFGT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYFGT5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYFGT5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:57:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYFGT53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:57:29 -0400
Date: Sat, 7 Jun 2008 15:50:42 -0400
From: Dave Jones <davej@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wrong hardlink count in /proc
Message-ID: <20080607195042.GB25998@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Willy Tarreau <w@1wt.eu>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20080607193424.GA25998@redhat.com> <20080607194604.GH5609@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607194604.GH5609@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 09:46:04PM +0200, Willy Tarreau wrote:
 > On Sat, Jun 07, 2008 at 03:34:24PM -0400, Dave Jones wrote:
 > > In 2.6.25, 'find /proc/ -name foo' will print out ..
 > > 
 > > find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
 > > in your filesystem driver.  Automatically turning on find's -noleaf
 > > option.  Earlier results may have failed to include directories that
 > > should have been searched.
 > 
 > I also encountered this one. I think it is the one which 2.6.25.6 stable
 > patch 42/50 fixes.

Ah, great.   I just noticed that .26rc doesn't seem affected, so sounds good.

Thanks,

	Dave

-- 
http://www.codemonkey.org.uk
