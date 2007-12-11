Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXLKNBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXLKNBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXLKNBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:01:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:44623 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLKNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=keKMZe1dBy+cENSLGmirG/jP9LB6zm2+8roWUaGrbWWYO3zWdxDQob6abDTXyNYWAZ7qrP6wLtNa0v3+IILl/uIkovyAxoZls7++X77CxvVxYRUiWYkMKS6xgE3kQb/YFwFH9uIfiE8NElmfQsML46ZQ8DBtMyjzSHwqonqs/XI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + revert-hibernation-enter-platform-hibernation-state-in-a-consistent-way.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:01:13 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, pavel@ucw.cz, rjw@sisk.pl
References: <200712110958.lBB9wDJl012816@imap1.linux-foundation.org>
In-Reply-To: <200712110958.lBB9wDJl012816@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111501.13754.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 11:58:09 akpm@linux-foundation.org wrote:
> 
> The patch titled
>      revert "Hibernation: Enter platform hibernation state in a consistent way"
> has been added to the -mm tree.  Its filename is
>      revert-hibernation-enter-platform-hibernation-state-in-a-consistent-way.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: revert "Hibernation: Enter platform hibernation state in a consistent way"
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Revert
> 
>     commit 9cd9a0058dd35268b24fa16795a92c800f4086d4
>     Author: Rafael J. Wysocki <rjw@sisk.pl>
>     Date:   Thu Oct 18 03:04:56 2007 -0700
> 
>         Hibernation: Enter platform hibernation state in a consistent way
> 
> Because it causes my t61p's suspend-to-RAM to immediately do a
> resume-from-RAM.
Noooo....

First of all, this commit doesn't touch the S3, so you probably
mean S4.

Secondary this commit just enables the wakeup devices in S4 mode.

It is just like removing the S4 altogether, it will also 'fix'
all the systems that don't suspend to disk properly.

At maximum there should be an option to do a mixed suspend
Enter using the firmware, but powerdown devices instead of suspend

Something like "platform_shutdown"

Best regards,
	Maxim Levitsky
