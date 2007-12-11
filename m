Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXLKTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXLKTO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXLKTOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:14:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15917 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbXLKTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:14:14 -0500
Date: Tue, 11 Dec 2007 11:12:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, "Greg KH" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>, <kay.sievers@vrfy.org>
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-Id: <20071211111231.dba901b6.randy.dunlap@oracle.com>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
References: <20071207171455.b2eecb60.randy.dunlap@oracle.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<20071210091501.deed38fa.randy.dunlap@oracle.com>
	<20071211145437.GA15617@linux.vnet.ibm.com>
	<20071211164319.GA14783@linux.vnet.ibm.com>
	<20071211170400.GA4861@suse.de>
	<20071211172338.GA17896@linux.vnet.ibm.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0015201EF@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<20071211182015.GA22339@linux.vnet.ibm.com>
	<20071211182528.GA5597@linux.vnet.ibm.com>
	<F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 14:08:15 -0500 Fortier,Vincent [Montreal] wrote:

> > -----Message d'origine-----
> > De : linux-kernel-owner@vger.kernel.org 
> > [mailto:linux-kernel-owner@vger.kernel.org] De la part de Dhaval Giani
> > 
> > > > 
> > > > My tests with Galaxy 5.9 shows that it still does not work.  
> > > > Although, the error seems to have changed a bit (see 
> > > > attached dmesg)
> > > > 
> > > 
> > > Hmmm, makes me suspect the bug is somewhere else. What I am 
> > > not able 
> > > to figure out is that I was able to recreate the trace you 
> > > had on my 
> > > systems. So there is a bug somewhere there.
> > > 
> > 
> > To make it clearer why I think so,
> > 
> > > [  638.466838] last sysfs file: /devices/platform/floppy.0/uevent
> > 				  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > That has changed from /sys/kernel/uids/<uid>/cpu_share
> > 
> 
> Here is my config.
> 
> Maybie I should give it a shot without CFS at all and see what happends

I agree.

---
~Randy
Features and documentation: http://lwn.net/Articles/260136/
