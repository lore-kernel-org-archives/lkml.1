Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYCaA4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYCaA4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 20:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYCaA4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 20:56:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:33822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYCaA4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 20:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,580,1199692800"; 
   d="scan'208";a="265948282"
Subject: Re: [PATCH 2/4] x86_64 boot -v2: Add linked list of struct
	setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080329233155.ee909a04.pj@sgi.com>
References: <1206672584.13404.25.camel@caritas-dev.intel.com>
	 <20080329233155.ee909a04.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 31 Mar 2008 08:54:37 +0800
Message-Id: <1206924877.21451.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Mar 2008 00:51:25.0495 (UTC) FILETIME=[58BD6C70:01C892C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 23:31 -0500, Paul Jackson wrote:
> Huang wrote:
> > +/* setup data types */
> > +#define SETUP_NONE			0
> 
> This define seems unused?

I think this can prevent somebody to use 0 as type id.

> Actually, what use would it ever have?  Should not every
> struct setup_data on the setup_data linked list have a
> valid (not NONE) type?  And perhaps that switch statement
> that confused me:
> 
> > +		switch (data->type) {
> > +		default:
> > +			break;
> > +		}
> 
> should not "break" silently on an unrecognized data->type, but
> rather complain bitterly?

Yes. A warning should be made on unrecognized data->type.

Best Regards,
Huang Ying
