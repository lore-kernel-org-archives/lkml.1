Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYJVHTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYJVHTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVHTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:19:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYJVHTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:19:40 -0400
Date: Wed, 22 Oct 2008 09:19:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 8/15 v5] PCI: add boot options to reassign resources
Message-ID: <20081022071909.GB27637@elte.hu>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com> <20081021114959.GI3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114959.GI3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yu Zhao <yu.zhao@intel.com> wrote:

> +static char *pci_assign_pio;
> +static char *pci_assign_mmio;
> +
> +static int pcibios_bus_resource_needs_fixup(struct pci_bus *bus)
> +{
> +	int i;
> +	int type = 0;
> +	int domain, busnr;
> +
> +	if (!bus->self)
> +		return 0;
> +
> +	for (i = 0; i < 2; i++) {
> +		char *str = i ? pci_assign_pio : pci_assign_mmio;
> +		while (str && *str) {

please put a newline after local variable defitions.

> +	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> +		struct resource *res = bus->resource[i];
> +		if (!res)

ditto.

nice debug feature!

	Ingo
