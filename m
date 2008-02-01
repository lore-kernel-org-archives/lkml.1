Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYBAP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYBAP6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYBAP6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:58:32 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:40738 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYBAP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:58:32 -0500
Date: Fri, 1 Feb 2008 07:58:22 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Joachim Deguara <joachim.deguara@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c II
In-Reply-To: <20080129080927.GA1414@one.firstfloor.org>
Message-ID: <alpine.DEB.1.00.0802010757030.7110@twinlark.arctic.org>
References: <200801281211.28214.joachim.deguara@amd.com> <p73y7a970nd.fsf@bingen.suse.de> <200801282012.47190.yinghai.lu@sun.com> <20080129045659.GA31847@one.firstfloor.org> <20080129080927.GA1414@one.firstfloor.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:

> > SRAT is essentially just a two dimensional table with node distances.
> 
> Sorry, that was actually SLIT. SRAT is not two dimensional, but also
> relatively simple. SLIT you don't really need to implement.

yeah but i'd heartily recommend implementing SLIT too.  mind you it's 
almost universal non-existence means i've had to resort to userland 
measurements to determine node distances and that won't change.  i guess i 
just wanted to grumble somewhere.

-dean
