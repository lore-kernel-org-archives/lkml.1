Return-Path: <linux-kernel-owner+w=401wt.eu-S935508AbYEVV7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508AbYEVV7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbYEVV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:59:15 -0400
Received: from xenotime.net ([66.160.160.81]:36686 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934279AbYEVV7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:59:14 -0400
Date: Thu, 22 May 2008 14:59:12 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alexey Starikovskiy <astarikovskiy@suse.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86: mp_bus_id_to_pci_bus is not needed, 
In-Reply-To: <alpine.LFD.1.10.0805222348110.3295@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.64.0805221456090.3694@shark.he.net>
References: <20080519154656.15071.96979.stgit@thinkpad>
 <20080519154709.15071.79793.stgit@thinkpad>
 <alpine.LFD.1.10.0805222348110.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Thomas Gleixner wrote:

> On Mon, 19 May 2008, Alexey Starikovskiy wrote:
> > @@ -101,7 +94,6 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
> >  static void __init MP_bus_info(struct mpc_config_bus *m)
> >  {
> >  	char str[7];
> > -
> >  	memcpy(str, m->mpc_bustype, 6);
> >  	str[6] = 0;
> 
> Please avoid such unrelated whitespace noise.

A few correct whitespace fixes shouldn't be a problem, but this one
isn't even a good change.

-- 
~Randy
