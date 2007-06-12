Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbXFLSEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbXFLSEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXFLSD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:03:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbXFLSD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:03:56 -0400
Date: Tue, 12 Jun 2007 14:03:48 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Allow softlockup to be runtime disabled.
Message-ID: <20070612180348.GB30839@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070612031354.GA18471@redhat.com> <1181648985.7348.305.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181648985.7348.305.camel@twins>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 01:49:45PM +0200, Peter Zijlstra wrote:
 > On Mon, 2007-06-11 at 23:13 -0400, Dave Jones wrote:
 > > It's useful sometimes to disable the softlockup checker at boottime.
 > > Especially if it triggers during a distro install.
 > 
 > Should we not rather fix these occurrences?

We do, but we can't easily fix the kernel that ends up on
install media.  It's easier to tell a user
"boot with nosoftlockup, then update your kernel after its installed"
than it is to guide them through reconstructing an ISO with
an updated kernel.

	Dave

-- 
http://www.codemonkey.org.uk
