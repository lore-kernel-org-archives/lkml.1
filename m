Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbYEVVus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbYEVVus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbYEVVuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:50:37 -0400
Received: from www.tglx.de ([62.245.132.106]:46202 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbYEVVuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:50:37 -0400
Date: Thu, 22 May 2008 23:50:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86: mp_bus_id_to_pci_bus is not needed, 
In-Reply-To: <20080519154709.15071.79793.stgit@thinkpad>
Message-ID: <alpine.LFD.1.10.0805222348110.3295@apollo.tec.linutronix.de>
References: <20080519154656.15071.96979.stgit@thinkpad> <20080519154709.15071.79793.stgit@thinkpad>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Alexey Starikovskiy wrote:
> @@ -101,7 +94,6 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
>  static void __init MP_bus_info(struct mpc_config_bus *m)
>  {
>  	char str[7];
> -
>  	memcpy(str, m->mpc_bustype, 6);
>  	str[6] = 0;

Please avoid such unrelated whitespace noise.

Thanks,
	tglx

