Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbXIUWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbXIUWxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765519AbXIUWhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:37:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:57473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765051AbXIUWhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:37:09 -0400
From: Andi Kleen <ak@suse.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] [20/45] x86_64: Use 8 byte stack alignment when possible
Date: Sat, 22 Sep 2007 00:34:31 +0200
User-Agent: KMail/1.9.1
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204502.2C61D14EFF@wotan.suse.de> <20070921211341.GC8127@redhat.com>
In-Reply-To: <20070921211341.GC8127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709220034.31227.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 23:13, Dave Jones wrote:
> On Fri, Sep 21, 2007 at 10:45:02PM +0200, Andi Kleen wrote:
>  > Kernel doesn't use SSE2, so it doesn't need 16 byte alignment. Also
>  > the stack can be already unaligned so letting the compiler align
>  > is useless. This may make some stack frames smaller.
>  > Only works with very recent gcc 4.3
>
> My gcc 4.1.2 from Fedora 7 (with who knows what backported)
> references this in its manpage. How was it broken before 4.3 ?

Try it. It is rejected by the compiler in 64bit mode.

-Andi
