Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZIOGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZIOGtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZIOGtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:49:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZIOGtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:49:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jYIcfFiG/qEEm7G9/SwQLYVdXu3kb3sKpmcy/1mafydVj7d3lqsXYnEbb7pcP2MWG
	KP+HPclM0Nn8In4cd/l7g==
Date: Mon, 14 Sep 2009 23:49:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Suresh Jayaram <sureshjayaram@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
In-Reply-To: <20090915063458.GC10232@core.coreip.homeip.net>
Message-ID: <alpine.DEB.1.00.0909142348220.9122@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org> <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com> <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com> <20090915063458.GC10232@core.coreip.homeip.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Dmitry Torokhov wrote:

> > The second is an issue with the i8042 driver's laptop table not being NULL 
> > terminated.  This is fixed by Jin Dongming's patch at
> > http://marc.info/?l=linux-kernel&m=125263897713267.
> > 
> 
> Should be good in my tree/next/mainline now.
> 

Ok thanks, but Suresh will still need to apply Jin's patch to test if 
mmotm-2009-09-14-01-57 works on T60p until the next -mm is released.
