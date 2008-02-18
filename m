Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYBRFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYBRFTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYBRFTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:19:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36630 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYBRFT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:19:29 -0500
Date: Sun, 17 Feb 2008 21:18:41 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: "Brown, Len" <len.brown@intel.com>
Cc: "Laurent Riffard" <laurent.riffard@free.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Stuart Bennett" <sb476@cam.ac.uk>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Message-ID: <20080217211841.41643a21@laptopd505.fenrus.org>
In-Reply-To: <CFF307C98FEABE47A452B27C06B85BB604826004@hdsmsx411.amr.corp.intel.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B7553D.5040601@free.fr>
	<47B75B10.3070700@linux.intel.com>
	<CFF307C98FEABE47A452B27C06B85BB604826004@hdsmsx411.amr.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 23:58:03 -0500
"Brown, Len" <len.brown@intel.com> wrote:

> >Len: This WARN_ON says that ACPI is trying to call ioremap() 
> >on memory that the e820_table
> >lists as "kernel owned". Do you know why ACPI would do this? 
> >Would ACPI get upset if
> >the kernel would tell it to take a hike?
> 
> Depends on the BIOS -- as it is the BIOS AML that is making this
> request.

is there any possible valid scenario where the BIOS AML would touch memory the 
kernel is using? (Since that seems to be what is going on; I'll cook up a diagnostics
patch to get more info but the warning gets spewed if ioremap() is trying to map
memory the kernel sees as ram)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
