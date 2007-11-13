Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbXKMVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbXKMVvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXKMVvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:51:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbXKMVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:51:00 -0500
Date: Tue, 13 Nov 2007 22:50:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       William Cohen <wcohen@redhat.com>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113215056.GB17593@one.firstfloor.org>
References: <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113214628.GE5747@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, horribly more complicated because of locking issues within perfmon.
> As soon as you expose a file descriptor, you need some locking to prevent
> multiple user threads (malicious or not) to compete to access the PMU state.

Why do you need the file descriptor? 

One of the main problems with perfmon is the complicated user interface.

Naively I would assume just some thread global state should be sufficient. 

> I think the value add of NMI can be as well achieved with advanced PMU features
> such as Intel Core 2 PEBS.

True probably, although only on CPUs that support PEBS. Dropping features
for old CPUs is unfortunately quite difficult in Linux, and in this case
probably not an option because there are so many of them (e.g. all of AMD
not Fam10h) 

-Andi
