Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYGAT5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYGAT5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGAT45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:56:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbYGAT4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:56:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Tue, 1 Jul 2008 21:58:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080701001727.GA4174@srcf.ucam.org> <20080701084648.GA21727@elte.hu>
In-Reply-To: <20080701084648.GA21727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807012158.34356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of July 2008, Ingo Molnar wrote:
> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > Assuming it works for Rafael (still haven't had time to pull my nx6125 
> > out of storage):
> > 
> > Signed-off-by: mjg@redhat.com
> 
> Rafael, could you please try the latest tip/master that i've just pushed 
> out:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> it has the final form of these changes integrated - it should in theory 
> work out of box on your system, with no boot parameters or other 
> explicit quirks needed anywhere.

I tested patches [1/2] (your version) and [2/2] on top of today's linux-next
and they work just fine.

Thanks,
Rafael
