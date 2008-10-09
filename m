Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbYJIRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbYJIRvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYJIRu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:50:59 -0400
Received: from sous-sol.org ([216.99.217.87]:50579 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756537AbYJIRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:50:58 -0400
Date: Thu, 9 Oct 2008 10:50:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Message-ID: <20081009175000.GC6912@sequoia.sous-sol.org>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com> <20081009130518.GE1623@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009130518.GE1623@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@suse.cz) wrote:
> > +struct tboot_acpi_sleep_info {
> > +	u16 pm1a_cnt;
> > +	u16 pm1b_cnt;
> > +	u16 pm1a_evt;
> > +	u16 pm1b_evt;
> > +	u16 pm1a_cnt_val;
> > +	u16 pm1b_cnt_val;
> > +}  __attribute__ ((__packed__));
> > +
> > +struct tboot_shared {
> > +	/* version 0x01+ fields: */
> > +	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
> > +	u32  version;      	/* Version number: 2 is current */
> > +	u32  log_addr;     	/* physical addr of tb_log_t log */
> > +	u32  shutdown_entry32;	/* entry point for tboot shutdown from
> > 32b */
> > +	u32  shutdown_entry64;	/* entry point for tboot shutdown from
> > 64b */
> 
> should these be function pointers?

I asked earlier, I didn't understand why it needs to be 2 fields, since
it's u32 in both cases and can't both be used at once.
