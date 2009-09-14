Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZINRqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZINRqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZINRpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:45:54 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:46890 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZINRpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:45:54 -0400
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       Jan Beulich <jbeulich@novell.com>
In-Reply-To: <20090914062520.GB23467@obsidianresearch.com>
References: <20090902031613.GA11464@obsidianresearch.com>
	 <20090903165219.2f79cdc1.akpm@linux-foundation.org>
	 <20090904012818.GU4973@obsidianresearch.com>
	 <alpine.LRH.2.00.0909141236020.28766@tundra.namei.org>
	 <20090914062520.GB23467@obsidianresearch.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 14:45:28 -0300
Message-Id: <1252950328.9372.154.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 00:25 -0600, Jason Gunthorpe wrote:
> On Mon, Sep 14, 2009 at 12:36:39PM +1000, James Morris wrote:
> > On Thu, 3 Sep 2009, Jason Gunthorpe wrote:
> 
> > > > That sounds like a fairly serious bug, and this looks like a 2.6.31
> > > > patch.
> > 
> > Any comments from the maintainers on this patch?
> 

Sorry for the delay, just reviewed the patches and Jason is right,
Jason's and Andrew's final work (last patch) is great.

> FWIW, I didn't mention in the patch emails, but all the patches I sent
> fix regressions that have been introduced in the past couple years by
> clean up patches that never tested the code paths they alter.
> 

Hold on, I tested these functions before when submitting them and they
worked fine, and, I couldn't figure it out why yet (only guesses), they
still work for me here, probably due the mishandling of the be32
formatted value when calling transmit_cmd().


Thanks,
Rajiv

