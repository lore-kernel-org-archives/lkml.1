Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYACRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYACRFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYACRE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:04:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbYACRE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:04:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 3/7] ACPI: Separate disabling of GPEs from _PTS
Date: Thu, 3 Jan 2008 18:07:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl> <200712271916.28675.rjw@sisk.pl> <20080103104345.GB1732@elf.ucw.cz>
In-Reply-To: <20080103104345.GB1732@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031807.14483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of January 2008, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The preparation to enter an ACPI system sleep state is now tied to
> > the disabling of GPEs, but the GPEs should not be disabled before
> > suspending devices.  Since on ACPI 1.0x systems the _PTS global
> > control method should be executed before suspending devices, we
> > need to disable GPEs separately.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Looks ok to me... as does rest of the series.

Thanks!
