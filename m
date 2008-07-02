Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYGBBJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYGBBJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYGBBJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:09:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47044 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbYGBBJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:09:33 -0400
Date: Wed, 2 Jul 2008 02:08:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: A minimally power-aware driver treats all messages as SUSPEND?
Message-ID: <20080702010857.GA27031@srcf.ucam.org>
References: <20080701072911.GA6564@digi.com> <200807011617.55501.rjw@sisk.pl> <20080701151415.GA17688@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080701151415.GA17688@digi.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 05:14:15PM +0200, Uwe Kleine-König wrote:

> With that I might have to do less on SUSPEND because some state might be
> preserved after the machine comes up again.

The only hardware state guaranteed by ACPI is the contents of RAM. It's 
valid for the platform to cut the power rails to everything else, so 
from a driver point of view it's almost always equivalent to 
hibernation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
