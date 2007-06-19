Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbXFSGIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbXFSGIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXFSGIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:08:11 -0400
Received: from jp1.linux-foundation.org ([207.189.120.31]:57762 "EHLO
	jp1.osdl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbXFSGIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:08:10 -0400
X-Greylist: delayed 1583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 02:08:10 EDT
Message-ID: <46776C9A.8080705@linux-foundation.jp>
Date: Tue, 19 Jun 2007 14:41:46 +0900
From: "Kunai, Takashi" <kunai@linux-foundation.jp>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: holzheu@linux.vnet.ibm.com
CC: Gerrit Huizenga <gh@us.ibm.com>, randy.dunlap@oracle.com,
       mtk-manpages@gmx.net, gregkh@suse.de, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>,
       schwidefsky@de.ibm.com, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Lf_kernel_messages] Re: [RFC/PATCH] Documentation of kernel
 messages
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com> <1182171354.11400.40.camel@localhost.localdomain>
In-Reply-To: <1182171354.11400.40.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I initiated this discussion in The Linux Foundation Summit@Google Campus
last week from the viewpoint of requirements by Japanese vendors/users.

As for a file to store message descriptions, I perfectly agree with your
analysis and we also noticed some (+) and (-) you pointed out in the
meeting last week. Our conclusion was to have a file outside of the
kernel source codes to lessen developers burdens and to encourage better
documentations of descriptions (as Andrew mentioned in his initial message).

Takashi Kunai,
The Linux Foundation Japan

holzheu wrote:
> Hi Gerrit,
> 
> The common thing of your and our approach is, that we need an ID to
> identify a message either by:
> 
> * Using hashes + component name (maybe)
> * Or using hand-made message numbers + component name. Numbers have
>   to be unique within the kernel component
> 
> I think the main difference of your approach is, that documentation will
> be maintained outside the kernel. This has advantages, but also
> disadvantages:
> 
> (+) Developers have less work to do :-)
> (+) Kernel sources and patches have less lines of code, since message
>     descriptions are not contained in the kernel sources.
> (+) You can support multiple languages
> 
> (-) Hard to keep printks and descriptions up-to-date. If using hashes,
>     each typo fix in a printk breaks the link to your documentation.
> (-) Since the developer knows the meaning of a printk best, he probably
>     would be the right person to write the description.
> (-) For every Distribution or vanilla kernel you probably need separate
>     external message databases.
> 
> I like the fact, that every printk gets an ID in your approach and you
> do not need additional printk macros.
> 
> Maybe both approaches are not mutually exclusive. If developers would
> like to document their messages within the kernel sources, they still
> could use kernel-doc and our KMSG_DOC macro do do that.
> 
> I admit, that I am not sure about the the best solution here.
> 
> Michael
> 
> 
> _______________________________________________
> Lf_kernel_messages mailing list
> Lf_kernel_messages@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/lf_kernel_messages
> 
> 


-- 
Kunai, Takashi
The Linux Foundation Japan (New since '07/2/5)
Shibuya Mark City West 22nd Floor
1-12-1 Dogenzaka,Shibuya-ku,Tokyo,Japan
zip150-0043 tel+81-3-4360-5493

