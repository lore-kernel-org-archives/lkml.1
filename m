Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186Ab0AEBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0AEBoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040Ab0AEBo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:44:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:48848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0AEBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:44:23 -0500
Date: Mon, 4 Jan 2010 17:45:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, Christian Hofstaedtler <ch@zeha.at>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100104174558.158cd512@infradead.org>
In-Reply-To: <4B4225B3.8070705@zytor.com>
References: <20100104162114.GA30113@percival.namespace.at>
	<alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
	<4B4225B3.8070705@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 09:30:27 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 01/04/2010 09:15 AM, Len Brown wrote:
> > 
> > I believe that Venki is sending a patch to make all recent
> > motherboards use acpi reset by default; and I'd rather
> > see that kind of patch than this one.
> > 
> > I've had the patch below patch in acpi-test, and thus linus-next,
> > and -mm since Nov 2008 to change the default for
> > all systems w/ no issues.
> > 
> 
> Maybe I'm misremembering, but didn't we have to pull this patch after
> it hit mainstream the last time?

can we do it based on the dmi/acpi year?
Eg for all 2008 and later machines or something, while leaving the
older ones as is



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
