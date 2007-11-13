Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbXKMUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbXKMUmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbXKMUmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:42:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37196 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137AbXKMUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:42:07 -0500
Date: Tue, 13 Nov 2007 21:42:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: William Cohen <wcohen@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113204205.GB17145@one.firstfloor.org>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4739C42F.8030208@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In the past I suggested that it might be useful to have a version of 
> perfmon2 that only set up the perfmon on a global basis. That would allow 

Context switch is imho the main differentiating feature of perfmon 
over oprofile.  Not sure it makes sense to take that one out.

I don't think the complexity of the patches comes from the context
switch anyways, it comes from the lots of other things it does.

-Andi
