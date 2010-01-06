Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535Ab0AFHVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0AFHVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672Ab0AFHVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:21:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:4459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0AFHVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:21:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,227,1262592000"; 
   d="scan'208";a="584700350"
Subject: Re: [PATCH 5/5] ACPI, APEI, Document for APEI
From: Huang Ying <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20100106071609.GA1648@ucw.cz>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-2-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-3-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-4-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-5-git-send-email-ying.huang@intel.com>
	 <1261980744-4450-6-git-send-email-ying.huang@intel.com>
	 <20100106071431.GB1494@ucw.cz>  <20100106071609.GA1648@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 15:21:43 +0800
Message-ID: <1262762503.17852.9.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 15:16 +0800, Pavel Machek wrote:
> > > +The user interface of EINJ is in debug file system, under the
> > > +directory apei/einj. The following files are provided.
> > > +
> > > +- available_error_type
> > > +  Read this file will return the error injection capability of the
> > > +  platform, that is, which error types are supported. The error type
> > > +  definition is as follow, the left field is the error type value, the
> > > +  right field is error description.
> > > +
> > > +    0x00000001	Processor Correctable
> > > +    0x00000002	Processor Uncorrectable non-fatal
> > > +    0x00000004	Processor Uncorrectable fatal
> > > +    0x00000008  Memory Correctable
> > > +    0x00000010  Memory Uncorrectable non-fatal
> > > +    0x00000020  Memory Uncorrectable fatal
> > > +    0x00000040	PCI Express Correctable
> > > +    0x00000080	PCI Express Uncorrectable fatal
> > > +    0x00000100	PCI Express Uncorrectable non-fatal
> > > +    0x00000200	Platform Correctable
> > > +    0x00000400	Platform Uncorrectable non-fatal
> > > +    0x00000800	Platform Uncorrectable fatal
> > > +
> > > +  The format of file contents are as above, except there are only the
> > > +  available error type lines.
> 
> Strange interface. Why not simply pass single integer -- the bit mask?
> Bit meanings are not going to change, anyway.

I have used bit mask in previous versions. But I think this version has
better readability.

Best Regards,
Huang Ying


