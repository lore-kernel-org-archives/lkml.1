Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXD3AmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXD3AmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422675AbXD3AmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:42:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422642AbXD3AmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:42:14 -0400
Date: Sun, 29 Apr 2007 20:40:50 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: "Moore, Robert" <robert.moore@intel.com>, Zhang@d975xbx2,
       Yanmin <yanmin.zhang@intel.com>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ACPI Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: ACPI interpreter errors (aer_init)
Message-ID: <20070430004050.GE14857@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>,
	"Moore, Robert" <robert.moore@intel.com>, Zhang@d975xbx2,
	Yanmin <yanmin.zhang@intel.com>,
	"Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux ACPI Mailing List <linux-acpi@vger.kernel.org>
References: <B28E9812BAF6E2498B7EC5C427F293A4025DC20B@orsmsx415.amr.corp.intel.com> <200704280231.52809.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704280231.52809.lenb@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 02:31:52AM -0400, Len Brown wrote:

 > On a quick glance, it appears that these messages have been in the aer driver
 > since it was born.
 > Did you run with CONFIG_PCIEAER in 2.6.19 or 2.6.20 and not have them there?
 > 
 > I agree with Bob, as status 5 is AE_NOT_FOUND,
 > it appears that the driver is being overly verbose,
 > even though these appear to all be KERN_DEBUG messages.

See this thread.. 

From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: lenb@kernel.org, us15@os.inf.tu-dresden.de, gregkh@suse.de, davej@redhat.com
Subject: [PATCH] reduce AER init error information

for a patch resolving this.

	Dave

-- 
http://www.codemonkey.org.uk
