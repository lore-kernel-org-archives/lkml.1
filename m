Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbXKMMeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbXKMMeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXKMMeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:34:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:41993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbXKMMd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:33:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
Date: Tue, 13 Nov 2007 13:33:41 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>,
       kiran@scalemp.com
References: <11946338683305-git-send-email-gcosta@redhat.com> <20071111180709.GG22277@bingen.suse.de> <47398C4A.40806@redhat.com>
In-Reply-To: <47398C4A.40806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131333.41946.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The vsmp_64.c file is now compiled unconditionally, according to which
> me and kiran agreed to. The detection code is always run, but will only
> trigger when a suitable box is found. Accordingly, the paravirt structs
> are only touched when PARAVIRT is on. Otherwise, we don't even have the
> symbols.

That seems dumb. What good is it if it doesn't patch the interrupt code?

-Andi
