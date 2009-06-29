Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZF2Okl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZF2Okl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZF2Oke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:40:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46750 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752276AbZF2Okd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:40:33 -0400
Date: Mon, 29 Jun 2009 15:41:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@linux.intel.com>,
       "Sergey Senozhatsky" <sergey.senozhatsky@mail.by>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
In-Reply-To: <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	<6JJ2m5kyucK.A.D2D.VJASKB@chimera>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 01:51:09 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).

Yes although getting people seeing to test with might_sleep() checks in
the tty layer demonstrate the tty layer isn't calling into ppp with irqs
disabled when it shouldn't so I'm at a loss as to whether this is a
network bug, a scheduler bug or something else.

The schedule error in __tasklet_schedule() is itself rather peicular.
