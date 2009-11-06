Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZKFAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZKFAYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZKFAYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:24:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:33747 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZKFAYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:24:40 -0500
X-ExtLoop1: 1
Subject: Re: [PATCH V2] x86: fix error return sequence in __ioremap_caller
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1257389031-20429-1-git-send-email-dfeng@redhat.com>
References: <20091104105149.GC13194@elte.hu>
	 <1257389031-20429-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 05 Nov 2009 16:23:16 -0800
Message-Id: <1257466996.4394.312.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 18:43 -0800, Xiaotian Feng wrote:
> kernel missed to free memtype if get_vm_area_caller failed in __ioremap_caller.
> This patch introduces error path to fix this and cleanup the repetitive error
> return sequence.  

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Thanks Xiaotian.

