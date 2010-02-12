Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0BLAZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:25:09 -0500
Received: from fisica.ufpr.br ([200.17.209.129]:37674 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0BLAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:25:07 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 19:25:07 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19316.40321.624092.859225@fisica.ufpr.br>
Date: Thu, 11 Feb 2010 22:14:57 -0200
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org mirrors] XZ Migration discussion
In-Reply-To: <4B745EFD.9030805@zytor.com>
References: <4B744E13.8040004@kernel.org>
	<4B745EFD.9030805@zytor.com>
X-Mailer: VM 8.0.13 under 23.1.1 (i486-pc-linux-gnu)
From: carlos@fisica.ufpr.br (Carlos Carvalho)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin (hpa@zytor.com) wrote on 11 February 2010 11:48:
 >On 02/11/2010 10:36 AM, J.H. wrote:
 >> 
 >> Option 1)
 >> 
 >> Leave gz as the master, and migrate bz2 to xz.  This will happen in
 >> stages obviously. with bz2 ultimately being phased out.
 >> 
 >> 	Migration option 1)
 >> 
 >> 		All new content would be provided in .bz2 and .xz with
 >> 		an ultimate date set that the .bz2 files would stop
 >> 		being generated with new content.  This would leave all
 >> 		existing content alone and it would not be a migration
 >> 		of the current .bz2 files to xz
 >> 
 >> 	Migration option 2)
 >> 
 >> 		At some point there would be a mass conversion of all
 >> 		existing content to include .bz2 and .xz.  These would
 >> 		be run in parallel for a time period until it was
 >> 		determined that .bz2 was no longer needed and it would
 >> 		be removed from the servers leaving .gz and .xz
 >> Option 2)
 >> 
 >> Convert the master data from gz to bz2 and use xz as the new file
 >> format.  This has the downside of causing more tool churn as it means
 >> the kernel developers will have to eventually convert from gz to bz2,
 >> which means for a time there will be nag e-mails if you upload gz
 >> instead of bz2 and such.  It would also mean that we (kernel.org) would
 >> need to be able to support .gz and .bz2 as master data for a time.
 >> 
 >> Migration options are identical to Option 1 more or less, with either
 >> just new content getting converted, or all content getting converted.
 >
 >My personal recommendation would be for Option 1, Migration option 2.

Agreed (speaking for the ftp.br.kernel.org mirror).
