Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbXKMNJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbXKMNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXKMNJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:09:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXKMNJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:09:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
Date: Tue, 13 Nov 2007 14:09:41 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>,
       kiran@scalemp.com
References: <11946338683305-git-send-email-gcosta@redhat.com> <200711131333.41946.ak@suse.de> <47399DC8.7000504@redhat.com>
In-Reply-To: <47399DC8.7000504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131409.41959.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If vsmp is selected, PARAVIRT will be too, and the interrupt code will
> be patched.
> the vsmp option triggers a select statement.
> 
> the ifdef only exists because, as I said, the code itself will be always
> compiled in, to avoid an ifdef in setup_64.c. So it's just a taking it
> from here, putting it there issue.

Peeking around needlessly in pci config space at each boot just to avoid an 
ifdef is not an good idea.

-Andi


