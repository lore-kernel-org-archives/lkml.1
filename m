Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYA0PiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYA0PiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYA0PiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:38:16 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:57618 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYA0PiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:38:15 -0500
Date: Sun, 27 Jan 2008 20:31:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080127150147.GA10914@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com> <20080126071339.GA25328@balbir.in.ibm.com> <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mackerras <paulus@samba.org> [2008-01-27 22:55:43]:

> Balbir Singh writes:
> 
> > Here's a better and more complete fix for the problem. Could you
> > please see if it works for you? I tested it on a real NUMA box and it
> > seemed to work fine there.
> 
> There are a couple of other changes in behaviour that your patch
> introduces, and I'd like to understand them better before taking the
> patch.  First, with your patch we don't set nodes online if they end
> up having no memory in them because of the memory limit, whereas
> previously we did.  Secondly, in the case where we don't have NUMA
> information, we now set node 0 online after adding each LMB, whereas
> previously we only set it online once.
> 
> If in fact these changes are benign, then your patch description
> should mention them and explain why they are benign.
>

Yes, they are. I'll try and justify the changes with a good detailed
changelog. If people prefer it, I can hide fake NUMA nodes under a
config option, so that it does not come enabled by default.

Thanks for keeping me honest.
 
> Paul.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
