Return-Path: <linux-kernel-owner+w=401wt.eu-S932731AbYARWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbYARWbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbYARWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:31:07 -0500
Received: from gw.goop.org ([64.81.55.164]:45271 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbYARWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:31:05 -0500
Message-ID: <479128A4.9070509@goop.org>
Date: Fri, 18 Jan 2008 14:31:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 0/10] Tree fixes for PARAVIRT
References: <12006768251548-git-send-email-gcosta@redhat.com>	 <20080118203259.GA3079@elte.hu>  <20080118213711.GA24979@elte.hu> <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1200693248.21817.157.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Why are we rushing so much to do 64-bit paravirt that we are breaking
> working configurations?  If the developement is going to be this
> chaotic, it should be done and tested out of tree until it can
> stabilize.
>   

x86.git is out of the mainline tree, and it seems to be working fairly 
smoothly.  I've come to appreciate the "lots of small patches with quick 
turnaround" model that Ingo has been pushing.

> I do not like having to continuously retest and review the x86 branch
> because the paravirt-ops are constantly in flux and the 32-bit code
> keeps breaking.
>   

Most of the activity is pure unification, with paravirt being part of 
that.  It doesn't help that it increases the CONFIG_ combinatorial 
explosion, but "make randconfig" shakes things out fairly quickly.

> We won't be doing 64-bit paravirt-ops for exactly this reason - is there
> a serious justification from the performance angle on modern 64-bit
> hardware?  If not, why justify the complexity and hackery to Linux?
>   

A big part of the rationale is to unify 32 and 64 bit, so that paravirt 
isn't a gratuitous difference between the two.  Also, 32 and 64 bit Xen 
have almost identical interface requirements, so the work is making 
64-bit Xen progress (and lguest64, of course).

    J
