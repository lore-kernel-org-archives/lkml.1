Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbXBWJlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbXBWJlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXBWJlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:41:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:57988 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXBWJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=DcF2hohL8u67C/DsL0kjEjWs4iaU2YppLpgyrEayQrf7t6S7pd/dRD0XDEuE6j+5+1iP5gipn1vUkrdzpW6t6d6LPCsit4Pvy4yB4dvUdgkvxjUw9WfBnMNIhS9t9wJAkG9RjP2fSm0M97Tc/7SZVD4zgLp1wjwwCd4NG7ALdUU=
Date: Fri, 23 Feb 2007 09:40:03 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: circular locking: /proc/sys/vm/drop_caches
Message-ID: <20070223094003.GG4113@slug>
References: <20070223063538.GA13679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223063538.GA13679@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 07:35:38AM +0100, Ingo Molnar wrote:
> 
> Andrew,
> 
> i just got the lockdep warning below when doing:
> 
>   echo 3 > /proc/sys/vm/drop_caches
> 
> is this a known quirk in the drop_caches code?
> 
This is known, yes: http://lkml.org/lkml/2006/12/4/19

Regards,
Frederik
