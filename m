Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZIUVU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZIUVU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZIUVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:20:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25606 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZIUVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:20:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: fixing "pci=use_crs"
Date: Mon, 21 Sep 2009 15:20:55 -0600
User-Agent: KMail/1.9.10
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909171016.50087.bjorn.helgaas@hp.com> <4AB50FF2.1070104@lwfinger.net>
In-Reply-To: <4AB50FF2.1070104@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909211520.56800.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 September 2009 11:08:02 am Larry Finger wrote:
> Bjorn Helgaas wrote:
> > It looks like you have an HP box -- what exactly is it and
> > what BIOS version do you have?  Maybe I can borrow one to play
> > with myself so I don't have to bug you as much.
> 
> It is an HP dv2815nr. The BIOS is F.21. I understand that debugging
> is much easier when you have the machine in hand, but I don't mind
> providing information.
> ...
> Do you want me to boot with "pci=use_crs"?

That'd be great.  HP's bureaucracy makes it hard for me to borrow
machines.  If you could also turn on CONFIG_PNP_DEBUG_MESSAGES
and boot with "pnp.debug", we should get some clues about what _CRS
returns for all the ACPI devices.  Just attach the resulting dmesg
to the bugzilla (http://bugzilla.kernel.org/show_bug.cgi?id=14183).

Bjorn
