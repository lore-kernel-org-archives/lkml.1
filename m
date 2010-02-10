Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0BJIXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0BJIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:23:42 -0500
Date: Wed, 10 Feb 2010 09:21:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "lkml@Think-Future.de" <lkml@Think-Future.de>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
Message-ID: <20100210082137.GA2519@dhcp-lab-161.englab.brq.redhat.com>
References: <20100206170348.GB9411@localhost> <20100208143118.e8e5a1ee.akpm@linux-foundation.org> <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com> <1265735092.2551.1835.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265735092.2551.1835.camel@rchatre-DESK>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Feb 09, 2010 at 09:04:52AM -0800, reinette chatre wrote:
> I do not understand your goal here ... as seen in this trace
> pci_alloc_consistent itself already calls dma_alloc_coherent right away.

We can call dma_alloc_coherent with GFP_KERNEL, pci_alloc_consistent is
more or less equal to dma_alloc_coherent with GFP_ATOMIC flag.

Stanislaw
