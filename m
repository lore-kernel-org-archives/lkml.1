Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZBSWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZBSWxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZBSWxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:53:42 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59789 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBSWxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:53:41 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFD] Automatic suspend
Date: Thu, 19 Feb 2009 23:58:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org> <200902192321.47891.rjw@sisk.pl>
In-Reply-To: <200902192321.47891.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902192358.13068.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 19 Februar 2009 23:21:46 schrieb Rafael J. Wysocki:
> > That's the whole point behind userspace wakelocks!  They provide a
> > mechanism for userspace to tell the kernel when (as far as userspace 
is
> > concerned) it is or is not okay to auto-sleep.
>
> Still, one can go further and observe that the user space can in fact start
> automatic suspend by itself whenever it knows it's appropriate ...

User space initiating this is a race condition.

	Regards
		Oliver

