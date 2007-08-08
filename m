Return-Path: <linux-kernel-owner+w=401wt.eu-S935959AbXHHS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935959AbXHHS2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXHHS14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:27:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34047 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXHHS1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:27:55 -0400
Message-ID: <46BA0B28.4090404@austin.ibm.com>
Date: Wed, 08 Aug 2007 13:27:52 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, jschopp <jschopp@austin.ibm.com>,
       apw@shadowen.org, rdunlap@xenotime.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Make checkpatch warn about pointless casting of kalloc returns.
References: <20070808024321.GA6316@redhat.com> <46B9F7C9.9060406@austin.ibm.com> <20070808180056.GF26440@redhat.com>
In-Reply-To: <20070808180056.GF26440@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > +			WARN("No need to cast return value.\n");
>  > 
>  > Could the warning be more descriptive?  This describes what, but it should also describe 
>  > why; after all if somebody made this error they may not know they why.
> 
> I'm open to suggestions..

How about

WARN("No need to cast return value, it is unnecessary and can hide real bugs.  See 
http://c-faq.com/malloc/mallocnocast.html for more details\n");
