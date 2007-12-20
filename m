Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbXLTHza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbXLTHza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 02:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbXLTHzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 02:55:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbXLTHzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:55:20 -0500
Date: Wed, 19 Dec 2007 23:53:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Voluntary leave_mm before entering ACPI C3
Message-ID: <20071219235357.53157cea@laptopd505.fenrus.org>
In-Reply-To: <4769757E.306@zytor.com>
References: <20071219183443.GA547@linux-os.sc.intel.com>
	<20071219193255.GA2158@elte.hu>
	<476972A0.3050105@zytor.com>
	<20071219194032.GA8849@elte.hu>
	<4769757E.306@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 11:48:14 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> 
> I think C3 guarantees that the cache contents stay intact, and thus
> it might make sense in some technology to preserve the TLB as well
> (being a kind of cache.)

that sounds nice. It's fiction though ;-)

The thing to realize is that linux only sees "ACPI C3"; the BIOS maps that C3 to.. well any of the C states the processor in the system has. What you're saying is afaik correct for the *hardware* C3, not for the "C3" that Linux sees..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
