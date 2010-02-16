Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab0BPQh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:37:28 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41922 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458Ab0BPQh0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:37:26 -0500
From: "Mukker, Atul" <Atul.Mukker@lsi.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Feb 2010 09:37:14 -0700
Subject: RE: [RFC]: new LSI MegaRAID driver implementation
Thread-Topic: [RFC]: new LSI MegaRAID driver implementation
Thread-Index: Acqua0gAavIOmAUHSwmDBq7XDrQ8XQAulWWQ
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7B79724D5@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
 <20100215181823.GA25776@infradead.org>
In-Reply-To: <20100215181823.GA25776@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the inputs Christoph.

We sort of had an idea for this possible route. What are your biggest concerns for a single driver model?

The split model has implications for LSI RAID management applications and we want to make sure that decision is made with a thorough analysis.
 
Regards,
Atul


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 15, 2010 1:18 PM
> To: Mukker, Atul
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC]: new LSI MegaRAID driver implementation
> 
> On Mon, Feb 15, 2010 at 10:09:23AM -0700, Mukker, Atul wrote:
> > We are anticipating about 70-80% of the current driver code to be
> changed. These changes would not be functional in nature though. The
> current functionality would be re-aligned in supporting functions. A
> parallel stream of functions would be created to support new HBAs.
> >
> > We are not anticipating changes in ways the new driver would work
> with the current generation of the HBAs and therefore we do not foresee
> any impact on the current functionality for these HBAs.
> >
> > We would like to solicit community feedback if this approach is
> acceptable. Alternative would be to leave the current driver untouched
> and submit a new driver for next generation of HBAs.
> >
> > Your inputs would be highly appreciated.
> 
> Please just add a new megaraid_<foo> driver, similar to how
> megaraid_sas
> is split from the legacy megaraid driver.  If the shared code is easy
> enough to factor it could be moved into a megaraid_common module, but
> in doubt I would not even bother with that.

