Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZJUBHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZJUBHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 21:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZJUBHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 21:07:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49254 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752638AbZJUBHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 21:07:14 -0400
Date: Tue, 20 Oct 2009 20:06:04 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3] x86/apic: limit irq affinity
Message-ID: <20091021010604.GA32196@sgi.com>
References: <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com> <4AD6B364.2050801@kernel.org> <20091015135039.GA24455@sgi.com> <20091020125649.GA25066@sgi.com> <20091020133810.GA26088@sgi.com> <4ADE085E.9050205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADE085E.9050205@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 11:58:38AM -0700, Yinghai Lu wrote:
> Dimitri Sivanich wrote:
> > +	cfg->node = node;
> 
> how about desc->node ?
>

Actually, desc->node does work for most of the cases here.  In the case where
it doesn't work, we have a pci device with the node information in it's device. 

Sending updated patch shortly.
