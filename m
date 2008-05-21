Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbYEUJdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbYEUJdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYEUJdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:33:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:39511 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbYEUJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PzyYGEUZY59yYyIoC1w3/c9Ple3TupBFN1IXHAf328PArXDanp4gBO/0Mz1LlyJv1n9nmkeAwli3k9OvrQOnYNLV/FQLOx+HPei7tAnWJ9y6eTwSCZWwQTruCaLs4sL0SAwZS4iBqlFJm47BAYpUMfKaUSS6xkfGinW0NLNn1ao=
Message-ID: <aa79d98a0805210233k420050b7vce5d76d3b1ad9677@mail.gmail.com>
Date: Wed, 21 May 2008 13:33:29 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] eCryptFS: fix missed mutex_unlock
Cc: "Michael A. Halcrow" <mhalcrow@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080521080205.GA11087@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080518142611.GA18000@cvg> <20080521080205.GA11087@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 12:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Ingo, could you please apply it and test? Actually I really doubt if
>> it help with the locking problem you pointed. There are two procedures
>> in miscrev.c - ecryptfs_miscdev_poll() and ecryptfs_miscdev_read()
>> which takes/releases mutexes in a bit strange way... investigating,
>> but this patch is needed anyway.
>
> btw., i didnt do any specific ecryptfs testing - randconfig enabled it
> and it got booted. So if you dont get the warning during
> bootup/module-load, you'll have the same test coverage i did.
>
>        Ingo
>

oh, thanks ;)
