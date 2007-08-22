Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbXHVVbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbXHVVbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763711AbXHVVbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:31:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:64421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762655AbXHVVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=lXZIIj84vbFVieXuvtyjxGydMpJdNsytaoX2XWbhRK5Ha9DUcATItWnP0E2aWpz7Jj3ABdUdojHbyMCANC+w8tLrudRehZRDgalCU9uou2a+AUf1fL/Ig5YizZOaftkNJ5ik015iGnnfuUo06PCDVUqqLyIs0z217gOM7zfZ57E=
Date: Wed, 22 Aug 2007 23:27:17 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: locking boot-time self-test failure
Message-ID: <20070822212717.GC31846@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708221926.39720.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221926.39720.m.kozlowski@tuxland.pl>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 07:26:39PM +0200, Mariusz Kozlowski wrote:
> 	Got that on my laptop:
> 
[...]
> -----------------------------------------------------------------
> BUG:   6 unexpected failures (out of 218) - debugging disabled! |
> -----------------------------------------------------------------

Hi Mariusz,

FWIW, reverting softlockup-use-cpu_clock-instead-of-sched_clock.patch
fixes the problem here.

Regards,
Frederik
