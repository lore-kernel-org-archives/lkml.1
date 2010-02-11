Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0BKTsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:48:38 -0500
Received: from mail.lang.hm ([64.81.33.126]:59128 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab0BKTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:48:37 -0500
Date: Thu, 11 Feb 2010 11:44:40 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "J.H." <warthog9@kernel.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, lasse.collin@tukaani.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: Re: XZ Migration discussion
In-Reply-To: <4B744E13.8040004@kernel.org>
Message-ID: <alpine.DEB.2.00.1002111138380.4721@asgard.lang.hm>
References: <4B744E13.8040004@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, J.H. wrote:

> Hey Everyone,
>
> So as the subject states this is more a centralized discussion on
> migration plans to using and providing xz for content on kernel.org.
> Currently we provide gz and bz2, with gz acting as the original content
> and kernel.org itself generating the resulting bz2 files.  There are a
> couple of possible proposals and wanted to toss them out there, and get
> feedback from everyone: the kernel community, the mirrors of kernel.org
> and the direct users of kernel.org.
>
> ========================================================================
>
> Option 1)
>
> Leave gz as the master, and migrate bz2 to xz.  This will happen in
> stages obviously. with bz2 ultimately being phased out.
>
> 	Migration option 1)
>
> 		All new content would be provided in .bz2 and .xz with
> 		an ultimate date set that the .bz2 files would stop
> 		being generated with new content.  This would leave all
> 		existing content alone and it would not be a migration
> 		of the current .bz2 files to xz
>
> 	Migration option 2)
>
> 		At some point there would be a mass conversion of all
> 		existing content to include .bz2 and .xz.  These would
> 		be run in parallel for a time period until it was
> 		determined that .bz2 was no longer needed and it would
> 		be removed from the servers leaving .gz and .xz
>
> Option 2)
>
> Convert the master data from gz to bz2 and use xz as the new file
> format.  This has the downside of causing more tool churn as it means
> the kernel developers will have to eventually convert from gz to bz2,
> which means for a time there will be nag e-mails if you upload gz
> instead of bz2 and such.  It would also mean that we (kernel.org) would
> need to be able to support .gz and .bz2 as master data for a time.
>
> Migration options are identical to Option 1 more or less, with either
> just new content getting converted, or all content getting converted.

I thought that the result of the poll that Linus did a few days ago was 
that there were advantages in having .gz, but that .xz was both smaller 
and faster than .bz2 and therefor the best thing to do would be to end up 
with .gz and .xz.

As such your option 2 doesn't seem like a reasonable path to go through.

David Lang
