Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZBIRbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZBIRbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbZBIRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:30:20 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35426 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbZBIRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:30:19 -0500
Subject: Re: mm_alloc()'ed structure leak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1234198023.5951.133.camel@laptop>
References: <1234181898.16083.26.camel@pc1117.cambridge.arm.com>
	 <1234190649.16083.44.camel@pc1117.cambridge.arm.com>
	 <1234192363.5951.129.camel@laptop>  <1234197950.5951.132.camel@laptop>
	 <1234198023.5951.133.camel@laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 09 Feb 2009 17:28:58 +0000
Message-Id: <1234200538.16083.52.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2009 17:29:03.0911 (UTC) FILETIME=[E7421B70:01C98ADB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 17:47 +0100, Peter Zijlstra wrote:
> On Mon, 2009-02-09 at 17:45 +0100, Peter Zijlstra wrote:
> > -               return -ERESTART_RESTARTBLOCK;
> > +               ret = -ERESTARTSYS;
> 
> noted and fixed.

I can confirm that with your patch, the leak is no longer reported.
Thanks.

-- 
Catalin

