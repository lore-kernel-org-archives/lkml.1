Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbYCGH7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbYCGH7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbYCGH7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:59:03 -0500
Received: from mail.southpole.se ([193.12.106.18]:54807 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622AbYCGH7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:59:01 -0500
Message-ID: <47D0F5BE.7010909@southpole.se>
Date: Fri, 07 Mar 2008 08:58:54 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] net: use DECLARE_PCI_DEVICE_TABLE
References: <1204800947-21569-1-git-send-email-jonas@southpole.se>	<1204800947-21569-2-git-send-email-jonas@southpole.se> <20080306154150.0ba906fa.akpm@linux-foundation.org>
In-Reply-To: <20080306154150.0ba906fa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Bah.
> 
> a) DECLARE_PCI_DEVICE_TABLE is misnamed.  It is used to *define* tables,
>    not to declare them.  It should be called DEFINE_PCI_DEVICE_TABLE.
> 

Fair enough...

> b) It's lame, anyway.  We could implement any number of such helper
>    thingies, but we choose not to.
> 

When I originally proposed these cleanups, I posted opened-coded 
versions.  That was deemed to be ugly and using a macro was suggested. 
So now I've reworked this with a macro, and now the macro is being 
deemed to be ugly, too!

The point of this exercise wasn't really to do a macro at all; the point 
was to get these structures marked 'const'  and into __devinitconst 
where they belong.  Whether the open-coded approach or the macro is the 
way to go, is all the same to me; any guidance on how to proceed would 
be appreciated.



