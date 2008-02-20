Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYBTRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYBTRwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYBTRwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:52:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:33187 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbYBTRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZO+pt7dd665FLT1PuF1G7TqRxg54SIyi99vV5tPsY9G/gc0Jd+V9p/3eDgziGa2Uvq6owY92A4Novqj5XwaiAK1QBQcuAapyLaSvyzkpAsyIR9dgPs8fDM4IRfIthnMVoeAdiwb86hpBnQa7+faN1Vh/jAcLqtzR/79C7zaM9qM=
Date: Wed, 20 Feb 2008 20:51:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220175145.GA6733@cvg>
References: <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com> <20080220131442.GA18790@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220131442.GA18790@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Feb 20, 2008 at 02:14:42PM +0100]
| On Wed, Feb 20, 2008 at 01:01:05PM +0000, David Howells wrote:
| > Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > 
| > > being see over vmlinux.lds for FRV architecture I found the string:
| > > 
| > > 	. = ALIGN(4096);
| > > 	.data.page_aligned : { *(.data.idt) }
| > > 
| > > though the PAGE_SIZE is 16K. Can't figure out why is that...
| > > Do you have a few spare minutes to explain, please?
| > 
| > Ummm...  Good question.  Probably a legacy thing.  I think the .data.idt
| > section is also an x86-only thing and should be dispensed with for FRV.
| > Leastways, the section has nothing in it according to the link map.
| 
| A quick grep agree with you.
| I see it used only in x86 in traps_32 for the F0 0F bug.
| It exist in several .lds files - including frv.
| 
| 	Sam
| 

Sam, maybe we should just eliminate this section at least for FRV?

		- Cyrill -
