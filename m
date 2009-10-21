Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZJUPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZJUPNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZJUPNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:13:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:10322 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZJUPNr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;11:1>);
	Wed, 21 Oct 2009 11:13:47 -0400
Message-Id: <4ADF4184020000780001B25B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Oct 2009 16:14:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Schlichter" <thomas.schlichter@web.de>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, <x86@kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       <dri-devel@lists.sourceforge.net>, "Ingo Molnar" <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not 
	 available
References: <1394923769@web.de>
In-Reply-To: <1394923769@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Schlichter <thomas.schlichter@web.de> 21.10.09 16:38 >>>
>Hmm, as far as I see mtrr_add() and mtrr_add_page() already check these
>constraints. Do you want me to check them additionally? Or do you want to
>completely fail the mmap() if these constraints are violated?

I'd say you should check it explicitly in the caller, to avoid the warning
message being printed otherwise.

>I'd let mmap() succeed even if the mtrr_add() fails...

Yes, of course.

Jan

