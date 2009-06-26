Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZFZWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZFZWmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZFZWlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:41:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZWlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:41:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] do_coredump: factor out put_cred() calls
In-Reply-To: Oleg Nesterov's message of  Friday, 26 June 2009 21:14:55 +0200 <20090626191455.GB22603@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626180222.GD7337@hmsreliant.think-freely.org>
	<20090626165908.GB12063@redhat.com>
	<20090626202411.GH7337@hmsreliant.think-freely.org>
	<20090626191418.GA22603@redhat.com>
	<20090626191455.GB22603@redhat.com>
X-Windows: simplicity made complex.
Message-Id: <20090626224054.162F8425A8@magilla.sf.frob.com>
Date: Fri, 26 Jun 2009 15:40:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (!binfmt || !binfmt->core_dump)
> -		goto fail;
> +		goto out;
[...]
> +out:
>  	return;
>  }

If the label does nothing, just use "return" instead of goto.

Thanks,
Roland

