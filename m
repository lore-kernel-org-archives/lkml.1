Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZELJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZELJuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZELJuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:50:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35621 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbZELJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:50:13 -0400
Date: Tue, 12 May 2009 11:55:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel support
Message-ID: <20090512095528.GG19296@one.firstfloor.org>
References: <4A03B9C3.9090607@intel.com> <20090508095748.GH3559@elte.hu> <4F65016F6CB04E49BFFA15D4F7B798D998BA8303@orsmsx506.amr.corp.intel.com> <20090512094544.GE32292@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512094544.GE32292@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +   ((void(*)(void))(long)tboot_shared->shutdown_entry)();
> 
> be better? Or is shutdown_entry always mapped into [0..2GB) on 

0..4GB and this code runs in a identity mapping.

> 64-bit? Even then, not sign-extending RIP addresses is wrong and 
> invites bugs/restrictions.

You never have to sign extend when going from 32bit to 64bit
on x86-64.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
