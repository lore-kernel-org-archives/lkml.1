Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXIUVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXIUVOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764931AbXIUVNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:13:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764787AbXIUVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:13:45 -0400
Date: Fri, 21 Sep 2007 17:13:41 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when
	possible
Message-ID: <20070921211341.GC8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204502.2C61D14EFF@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921204502.2C61D14EFF@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 10:45:02PM +0200, Andi Kleen wrote:
 > 
 > Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
 > the stack can be already unaligned so letting the compiler align
 > is useless. This may make some stack frames smaller.
 > Only works with very recent gcc 4.3

My gcc 4.1.2 from Fedora 7 (with who knows what backported)
references this in its manpage. How was it broken before 4.3 ?
(I'm curious if I'll suddenly see not expected behaviour with
 this change with that compiler).

	Dave

-- 
http://www.codemonkey.org.uk
