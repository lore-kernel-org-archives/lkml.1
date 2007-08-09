Return-Path: <linux-kernel-owner+w=401wt.eu-S940445AbXHIQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940445AbXHIQYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940812AbXHIQYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:24:06 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:1746 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940747AbXHIQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:24:04 -0400
Date: Thu, 9 Aug 2007 19:24:02 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [patches] [PATCH] [4/12] x86_64: Disable CLFLUSH support again
Message-ID: <20070809162402.GC4471@rhun.haifa.ibm.com>
References: <20070809241.425881000@suse.de> <20070809124131.B6E6114F3B@wotan.suse.de> <20070809131121.GL3311@rhun.haifa.ibm.com> <46BB32F6.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BB32F6.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 02:29:58PM +0100, Jan Beulich wrote:

> The issue here is not with clflush by itself, but with what pages it
> is being applied to. Here, it gets used on page table pages when
> flushing really is needed on what one or more page table entries in
> that page table page point(ed) to.

I see, thanks.

Cheers,
Muli
