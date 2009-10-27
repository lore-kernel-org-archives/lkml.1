Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZJ0VKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZJ0VKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbZJ0VKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:10:33 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:50769 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbZJ0VKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ppen8riByTztuk2jQB+YwlDz+t8B4mSwucDoBVNbtVp33VPRwkuesLzVq+4V5lTlCG
         5wXBxmDjViz8VFe268GMDLfG+/Taiiwq9vU2EzWj+T9pvU+aKpO52ab2pjPhfkTM6/Ig
         Fyfk+TdXvT9RqDkT++ftXEK/XeBcwNx22IRYY=
Date: Wed, 28 Oct 2009 00:10:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
Message-ID: <20091027211033.GN5893@lenovo>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091027205558.GM5893@lenovo> <alpine.DEB.2.00.0910271404580.9183@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271404580.9183@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Tue, Oct 27, 2009 at 02:06:21PM -0700]
| On Tue, 27 Oct 2009, Cyrill Gorcunov wrote:
| 
| > | +void __init acpi_numa_print_srat_mapping(void)
| > | +{
| > | +	int i, j;
| > | +
| > | +	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
| > | +		int nid;
| > | +
| > | +		nid = pxm_to_node(i);
| > | +		if (nid == NUMA_NO_NODE)
| > 
| > Btw, David, while you at it, I just curious -- shouldn't we test it
| > with NID_INVAL (as pxm_to_node_map initially defined to)? Not a big
| > deal at all (since they are both = -1) but for the record.
| > Or perhaps I miss something?
| > 
| 
| I don't think we need to address that since NID_INVAL is going away and 
| will be replaced by NUMA_NO_NODE since Lee has exposed it globally in his 
| mempolicy patchset, and as you mention they are the same anyway.
| 

I see. Thanks!

	-- Cyrill
