Return-Path: <linux-kernel-owner+w=401wt.eu-S965647AbXCVEDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647AbXCVEDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965654AbXCVEDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:03:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33403 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965647AbXCVEDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:03:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Use X86_EFLAGS_IF in irqflags.h, lguest. 
In-reply-to: Your message of "Thu, 22 Mar 2007 14:52:29 +1100."
             <1174535550.2713.108.camel@localhost.localdomain> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 22 Mar 2007 15:03:19 +1100
Message-ID: <11208.1174536199@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell (on Thu, 22 Mar 2007 14:52:29 +1100) wrote:
>On Thu, 2007-03-22 at 14:24 +1100, Rusty Russell wrote:
>> Belay this: there's a X86_EFLAGS_IF in asm/processor.h which we should
>> use.  Will send patch.
>
>How's this.  There may be other users, but they're not easy to grep for.

One less set of definitions for KDB to create - Thanks.

