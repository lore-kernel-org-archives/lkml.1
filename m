Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZJSNq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZJSNq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZJSNq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:46:56 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:37302 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZJSNqz (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 19 Oct 2009 09:46:55 -0400
Date: Mon, 19 Oct 2009 09:36:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Jan Beulich <JBeulich@novell.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       Ingo Molnar <mingo@redhat.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       dri-devel@lists.sourceforge.net, Yinghai Lu <yinghai@kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	available
Message-ID: <20091019133618.GA12359@phenom.dumpdata.com>
References: <4AD449A702000078000197EE@vpn.id2.novell.com> <200910142114.12433.thomas.schlichter@web.de> <4AD6EFD7020000780001A067@vpn.id2.novell.com> <200910172148.36267.thomas.schlichter@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910172148.36267.thomas.schlichter@web.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4ADC6D63.0101:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> X.org uses libpciaccess which tries to mmap with write combining enabled via
> /sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, we
> fall back to uncached mmap. Then libpciaccess thinks it succeeded mapping
> with write combining anabled and does not set up suited MTRR entries. ;-(

I am not familiar with libpciaccess, but I was wondering why that library
cannot realize it failed in its endeavour and use other means to accomplish
its goals?

