Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995Ab0ATMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0ATMKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580Ab0ATMKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:10:14 -0500
Received: from lo.gmane.org ([80.91.229.12]:50148 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0ATMKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:10:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] MIPS: cleanup switches with cases that can be merged
Date: Wed, 20 Jan 2010 11:47:29 +0000
Message-ID: <h37j27-hgu.ln1@chipmunk.wormnet.eu>
References: <4B56475F.8070608@gmail.com> <4B56641E.1030803@caviumnetworks.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Cc: linux-mips@linux-mips.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.ports.mips.general David Daney <ddaney@caviumnetworks.com> wrote:
>
> [snipped]
> 
> This brings us to the larger question:  This is just code churn.  Is it 
> even worthwhile?
> 
Anything which reduces the line count and remove duplication whilst 
sticking to CodingStyle I would always argue for, but "who am I" :)

It at a glance, this type of code churn, shows there are no differences 
between two classes of <whatever> and the effect is it makes the chunk 
of code a mental NOOP for the person reading the code. :)

To me this is a natural extension of running with Chapter 14 of 
CodingStyle where you kmalloc using 'sizeof(*p)' rather than 
'sizeof(struct *foo)' so reducing the chance of errors later on.

Just my thoughts.

Cheers

-- 
Alexander Clouter
.sigmonster says: Snoopy: No problem is so big that it can't be run away from.

