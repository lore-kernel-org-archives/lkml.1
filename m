Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZD0T4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZD0T4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZD0T4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:56:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044AbZD0T4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:56:04 -0400
Date: Mon, 27 Apr 2009 12:52:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: ebmunson@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@csn.ul.ie, cl@linux-foundation.org
Subject: Re: [PATCH] Display 0 in meminfo for Committed_AS when value
 underflows
Message-Id: <20090427125208.94730dd8.akpm@linux-foundation.org>
In-Reply-To: <1240848914.29485.52.camel@nimitz>
References: <1240848620-16751-1-git-send-email-ebmunson@us.ibm.com>
	<1240848914.29485.52.camel@nimitz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 09:15:14 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Mon, 2009-04-27 at 17:10 +0100, Eric B Munson wrote:
> > Splitting this patch from the chunk that addresses the cause of the underflow
> > because the solution still requires some discussion.
> > 
> > Dave Hansen reported that under certain cirumstances the Committed_AS value
> > can underflow which causes extremely large numbers to be displayed in
> > meminfo.  This patch adds an underflow check to meminfo_proc_show() for the
> > Committed_AS value.  Most fields in /proc/meminfo already have an underflow
> > check, this brings Committed_AS into line.
> 
> Yeah, this is the right fix for now until we can iron out the base
> issues.  Eric, I think this may also be a candidate for -stable.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

I cannot find Eric's original patch anywhere.  Did some demented MTA munch it?

