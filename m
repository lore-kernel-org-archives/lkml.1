Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYEHOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYEHOwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYEHOwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:52:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60096 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbYEHOwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:52:40 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080508143453.GE12654@escobedo.amd.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
	 <20080506124946.GA2146@elte.hu>
	 <Pine.LNX.4.64.0805061435510.32567@blonde.site>
	 <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0805062043580.11647@blonde.site>
	 <20080506202201.GB12654@escobedo.amd.com>
	 <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 07:52:30 -0700
Message-Id: <1210258350.7905.45.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 16:34 +0200, Hans Rosenfeld wrote:
> While trying to reproduce this, I noticed that the huge page wouldn't
> leak when I just mmapped it and exited without explicitly unmapping, as
> I described before. The huge page is leaked only when the
> /proc/self/pagemap entry for the huge page is read.

Well, that's an interesting data point! :)

Are you running any of your /proc/<pid>/pagemap patches?

-- Dave

