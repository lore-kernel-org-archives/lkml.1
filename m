Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZINSBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZINSBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbZINSA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:00:59 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:43171 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756216AbZINSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:00:58 -0400
Date: Mon, 14 Sep 2009 12:00:39 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
Message-ID: <20090914180039.GA25981@obsidianresearch.com>
References: <20090902031613.GA11464@obsidianresearch.com> <20090903165219.2f79cdc1.akpm@linux-foundation.org> <20090904012818.GU4973@obsidianresearch.com> <alpine.LRH.2.00.0909141236020.28766@tundra.namei.org> <20090914062520.GB23467@obsidianresearch.com> <1252950328.9372.154.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252950328.9372.154.camel@blackbox>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 02:45:28PM -0300, Rajiv Andrade wrote:

> Sorry for the delay, just reviewed the patches and Jason is right,
> Jason's and Andrew's final work (last patch) is great.

Thnx
 
> > FWIW, I didn't mention in the patch emails, but all the patches I sent
> > fix regressions that have been introduced in the past couple years by
> > clean up patches that never tested the code paths they alter.

> Hold on, I tested these functions before when submitting them and they
> worked fine, and, I couldn't figure it out why yet (only guesses), they
> still work for me here, probably due the mishandling of the be32
> formatted value when calling transmit_cmd().

Ahh, yes, you are right, the pcr thing wouldn't blow up on a LE
system, I'm testing on BE. Didn't notice that subtlety. Sorry

Also please look at the last patch Andrew has queued up:
http://patchwork.kernel.org/patch/45512/

Regards,
Jason
