Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab0CASxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:53:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:63385 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0CASxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,561,1262592000"; 
   d="scan'208";a="600232838"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Richard Hartmann <richih.mailinglist@gmail.com>,
       "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Pochinsky <avp@MIT.EDU>
Date: Mon, 1 Mar 2010 11:53:40 -0700
Subject: RE: [E1000-devel] New thread: page allocation failure with E1000
 (seems	to be reproducible)
Thread-Topic: [E1000-devel] New thread: page allocation failure with E1000
 (seems	to be reproducible)
Thread-Index: Acq20JCLD8Wksy4oQDaFrqNAsvB1GACn8IAQ
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FE44137C0@rrsmsx501.amr.corp.intel.com>
References: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
In-Reply-To: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
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

Richard Hartmann wrote:
> Hi all,
> 
> this is a re-send of my original email to e1000-devel@lists.sf.net. It
> includes all information at once and is sent to LKML as well. I am
> CC'ing Andrew Pochinsky because http://lkml.org/lkml/2008/6/10/3 is
> related.
> 
> 
> 
> I deployed Bacula storage director (i.e. a backup target) on a machine
> which has been running in test mode for some time, now. This past
> night 
> is the first one in which it received significant traffic from several
> other machines, 62 in total.
> My host has four Intel E1000 which are bonded into one virtual
> interface. The other side is a Cisco 6500.
> 
> At 00:00, at a peak rate of 1.2 Gbit/s, I had ten(!) page allocation
> failures within seconds:

Can you post your kernel config?

Thanks,
Emil
