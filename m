Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYAHA65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYAHA65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYAHA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:58:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35438 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYAHA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:58:48 -0500
Date: Tue, 8 Jan 2008 02:01:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       akpm@osdl.org, rajesh.shah@intel.com, greg@kroah.com
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
Message-ID: <20080108010110.GB16156@one.firstfloor.org>
References: <20080107224757.GA2336@basil.nowhere.org> <200801071452.15045.jbarnes@virtuousgeek.org> <4782B66E.8050400@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4782B66E.8050400@shaw.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 05:31:58PM -0600, Robert Hancock wrote:
> Jesse Barnes wrote:

Hmm -- I didn't see Jesse's mail? 

> I believe that such a change is in Greg KH's tree. So -mm (with both 
> trees) would probably work.

Yes 2.6.24-rc6-mm1 works, but plain git-x86 does not:

PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f0000000 - f7ffffff

-Andi

> 
