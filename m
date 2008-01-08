Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYAHQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYAHQLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAHQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:11:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51111 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYAHQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:11:43 -0500
Date: Tue, 8 Jan 2008 17:14:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Hancock <hancockr@shaw.ca>, Andi Kleen <andi@firstfloor.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, akpm@osdl.org, rajesh.shah@intel.com,
       greg@kroah.com
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
Message-ID: <20080108161409.GB31504@one.firstfloor.org>
References: <20080107224757.GA2336@basil.nowhere.org> <200801071452.15045.jbarnes@virtuousgeek.org> <4782B66E.8050400@shaw.ca> <20080108010110.GB16156@one.firstfloor.org> <4782CBF2.6030208@shaw.ca> <20080108081543.GF31838@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108081543.GF31838@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:15:43AM +0100, Ingo Molnar wrote:
> 
> * Robert Hancock <hancockr@shaw.ca> wrote:
> 
> > At least, I thought it was in Greg's tree, not sure now.. This is the 
> > patch in -mm:
> >
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during-sizing-of-bars.patch
> >
> > Without this change a bunch of machines fail to boot even without the 
> > MCFG change (since their MCFG was E820 reserved and so the old 
> > validation check passed).
> 
> Andi, can you confirm that your box boots fine with that patch applied?

Yes it does.

-Andi
