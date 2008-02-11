Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYBKRcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYBKRcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYBKRcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:32:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47257 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752796AbYBKRcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:32:23 -0500
Message-ID: <47B086A3.9040508@sgi.com>
Date: Mon, 11 Feb 2008 09:32:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [PATCH 1/4] cpufreq: change cpu freq tables to per_cpu	variables
References: <20080208233738.108449000@polaris-admin.engr.sgi.com> <20080208233738.292421000@polaris-admin.engr.sgi.com> <20080211024835.GD26696@codemonkey.org.uk>
In-Reply-To: <20080211024835.GD26696@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Feb 08, 2008 at 03:37:39PM -0800, Mike Travis wrote:
>  > Change cpu frequency tables from arrays to per_cpu variables.
>  > 
>  > Based on linux-2.6.git + x86.git
> 
> Looks ok to me.   Would you like me to push this though cpufreq.git,
> or do you want the series to go through all in one?
> 
> 	Dave
> 

Thanks Dave.  The patches are pretty much independent but it is
easier to keep track of them if they go in together.  Btw, I have
another set coming shortly that I'm testing now.  It should remove
most of the remaining references to NR_CPUS.

Thanks again,
Mike
