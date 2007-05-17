Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXEQGgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXEQGgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEQGgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:36:37 -0400
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:39656 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXEQGgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:36:36 -0400
Message-ID: <464BF7E5.4080105@codewiz.org>
Date: Thu, 17 May 2007 02:36:21 -0400
From: Bernardo Innocenti <bernie@codewiz.org>
Organization: http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Keith Owens <kaos@sgi.com>
CC: Jordan Crouse <jordan.crouse@amd.com>, kdb@oss.sgi.com,
       linux-kernel@vger.kernel.org, devel@laptop.org
Subject: Re: kdb: add rdmsr and wrmsr commands for i386
References: <6778.1179382953@kao2.melbourne.sgi.com>
In-Reply-To: <6778.1179382953@kao2.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Owens wrote:

> Before using MSR, you must first check that the cpu supports the
> instruction, rd/wrmsr cause an oops on 486 or earlier.  Also using an
> invalid msr number causes an oops, so use rd/wrmsr_safe().

I didn't bother implementing those checks because kdb recovers
nicely from GPF anyway.  It's the valid MSR writes that could
cause unrecoveable problems! :)

-- 
   // Bernardo Innocenti
 \X/  http://www.codewiz.org/
