Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYC1G2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYC1G2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYC1G2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:28:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYC1G2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:28:19 -0400
Date: Fri, 28 Mar 2008 07:31:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64 boot -v2: Add linked listof struct setup_data to boot protocol
Message-ID: <20080328063142.GN29105@one.firstfloor.org>
References: <1206672578.13404.21.camel@caritas-dev.intel.com> <86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803272233ved9c1d6w44f8722c85cf4c62@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:33:27PM -0700, Yinghai Lu wrote:
> On Thu, Mar 27, 2008 at 7:49 PM, Huang, Ying <ying.huang@intel.com> wrote:
> > This patchset adds the linked list of struct setup_data to boot
> >  protocol. This is needed by EDD information and some SGI machine with
> >  E820 entry number > 128.
> 
> interesting, that 512nodes/4096 box physics memory is not continuous?

Likely not. That would require huge hardware overhead for all the
comparators to handle variable ranges.  Much easier to just use some higher bits 
in the address to index nodes.

-Andi
