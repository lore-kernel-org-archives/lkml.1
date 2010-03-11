Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0CKNpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:45:15 -0500
Received: from centrinvest.ru ([94.25.115.130]:36488 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab0CKNpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:45:12 -0500
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Thu, 11 Mar 2010 16:45:08 +0300
To: James Lamanna <jlamanna@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
Message-ID: <20100311134508.GB29239@centrinvest.ru>
Mail-Followup-To: James Lamanna <jlamanna@gmail.com>,
	Robert Hancock <hancockrwd@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
 <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
 <4B95B028.3050106@gmail.com>
 <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com>
 <20100309141552.GD30538@centrinvest.ru>
 <8DFD46FA-A938-41D6-97EC-F6E5324C9FAA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DFD46FA-A938-41D6-97EC-F6E5324C9FAA@gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 068, 03 09, 2010 at 07:09:21AM -0800, James Lamanna wrote:
> On Mar 9, 2010, at 6:15, "Andrey Panin" <pazke@centrinvest.ru> wrote:
> 
> >On 067, 03 08, 2010 at 09:15:26PM -0800, James Lamanna wrote:
> >
> >>That's probably the case.
> >>It looks like 8250 doesn't know about this PCIe device at all.
> >>The Oxford PCI ID is not in pci_ids.h nor is the SIIG subsystem ID.
> >>I'll see if I can maybe work up a patch to support this device,
> >>since I've found
> >>the datasheet for the Oxford 4 port UART controller, but I may
> >>need some help.
> >>Or if anyone else (who has more experience with this) wants to
> >>formulate one,
> >>it would be greatly appreciated.
> >
> >Looks like you card can use existing code for Oxford Semiconductor
> >UARTs.
> >Can you test the attached patch for 2.6.33 ?
> 
> Hi Andrey,
> Coincidentally I found your patch for 2.6.28 that I was able to
> backport to 2.6.24. The card seems to be working great!
> Is this patch in mainline now?

Now I'm confused, because I can't remember SIIG related patches for 2.6.28.
