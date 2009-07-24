Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZGXKlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZGXKlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZGXKlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:41:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47305 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbZGXKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:41:30 -0400
Date: Fri, 24 Jul 2009 11:42:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.orglanga2,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Panic on IBMMCA SCSI driver with 2.6.30
Message-ID: <20090724114231.23006564@lxorguk.ukuu.org.uk>
In-Reply-To: <1248406465.24021.734.camel@nimitz>
References: <1248406465.24021.734.camel@nimitz>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 20:34:24 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> No, this isn't a joke.  I actually still have an IBM 9595, and I've been
> running 2.4 on it all this time.  A friend of mine tried to upgrade one
> to 2.6 and couldn't get it to boot.  I managed to get a bit of serial
> console output of the error it is throwing.  I don't speak SCSI very
> well, so I'm hoping that you guys might have some insight.

Not a lot - the SCSI adapter in question is more of a smart controller
and I suspect the trap is because it was fed junk (eg invalid sg lists).
I doubt it gets tested very much somehow.
