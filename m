Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYLaT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYLaT1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYLaT1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:27:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216AbYLaT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:27:01 -0500
Date: Wed, 31 Dec 2008 11:26:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
Message-Id: <20081231112645.b1867977.akpm@linux-foundation.org>
In-Reply-To: <495B90D5.5090903@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<1229439174-30492-1-git-send-email-bharrosh@panasas.com>
	<20081229122959.2cb48cf7.akpm@linux-foundation.org>
	<495B90D5.5090903@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 17:33:41 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> Andrew Morton wrote:
> >> +int prepare_get_attr_list_add_entry(struct osd_request *req,
> >> +				    uint32_t page_num,
> >> +				    uint32_t attr_num,
> >> +				    uint32_t attr_len)
> >> +{
> >> +	struct osd_attr attr = {
> >> +		.page = page_num,
> > 
> > Kernel developers expect a field called "page" to have type `struct
> > page *'.  osd_attr.page is thus designed to confuse.
> > 
> >> ...
> >>
> > 
> 
> Rant below (can be ignored):
>   This single fix will cause a massive change to the open-osd
>   initiator patchset, (18 patches), and resubmission .I made the mistake
>   because this name originates from a file that all naming conventions
>   are taken from the OSD standard text. However this is no excuse
>   for using a well known Kernel construct name. I will fix it. And
>   will be more careful in the future.

The world wouldn't end if you left the code as-is.  We've done worse things :)
