Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYIWWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYIWWA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYIWWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYIWWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:00:19 -0400
Message-ID: <48D966AE.1040008@linux-foundation.org>
Date: Tue, 23 Sep 2008 16:59:10 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com> <48CBF25B.5030107@goop.org> <20080914132952.GC554@elte.hu> <48CD1D1E.1050906@goop.org> <20080914142213.GA28162@elte.hu> <20080923214558.GA13357@linux-os.sc.intel.com>
In-Reply-To: <20080923214558.GA13357@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd suggest to avoid the open coding of page flag handling using set bit etc.

It may be best to slowly migrate the arch specific definitions into
page-flags.h. Otherwise we wont have a central authority on page flags.

