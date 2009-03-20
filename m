Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbZCTA7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbZCTA7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZCTA6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:58:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:46540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZCTA6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,392,1233561600"; 
   d="scan'208";a="674436128"
Subject: Re: 2.6.29 acpi regression: acpi_ex_extract_from_field -- div by
 zero
From: Lin Ming <ming.m.lin@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
In-Reply-To: <49C26D91.3010904@gmail.com>
References: <49BCDCAA.8040309@gmail.com>
	 <d3f22a0903152046m891dc0aq6ca01eed32a9eb32@mail.gmail.com>
	 <1237174943.4193.37.camel@minggr.sh.intel.com> <49BE7EE6.3070107@gmail.com>
	 <49C0AC13.7040107@gmail.com>  <49C26D91.3010904@gmail.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 08:48:37 +0800
Message-Id: <1237510117.879.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 00:06 +0800, Jiri Slaby wrote:
> On 18.3.2009 09:08, Jiri Slaby wrote:
> > On 16.3.2009 17:31, Jiri Slaby wrote:
> >> On 16.3.2009 04:42, Lin Ming wrote:
> >>>> sometimes, when booting up/resuming from disk, I get an oops[1].
> >>>>
> >>>> obj_desc->common_field.access_bit_width is zero, but even after the
> >>>> loop. Division before the loop is apparently OK.
> >>>
> >>> Would please try below debug patch to see which region filed is
> >>> accessed?
> >
> > I'm confused, but keep trying.
> 
> Got it again. obj_desc->common_field.node is martian too (0x4000000), so 
> the added acpi_get_name dies:
> http://www.fi.muni.cz/~xslaby/sklad/panics/acpi_oops1.png
> 
> Whole common_field seems to be mangled. Ideas?

Thanks for the info. We are looking at this.

Lin Ming

