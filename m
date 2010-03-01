Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0CAEip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 23:38:45 -0500
Received: from relay.atmel.no ([80.232.32.139]:53073 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0CAEin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 23:38:43 -0500
Date: Mon, 1 Mar 2010 11:37:25 +0700
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Anders Kaseorg <andersk@ksplice.com>,
       Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 17/24] Rename .text.reset to .text..reset.
Message-ID: <20100301113725.7486577b@hskinnemoen-d830>
In-Reply-To: <alpine.DEB.1.10.1002282126420.6474@dr-wily.mit.edu>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
	<1266624237-22372-18-git-send-email-vda.linux@googlemail.com>
	<alpine.DEB.1.10.1002282126420.6474@dr-wily.mit.edu>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott <tabbott@ksplice.com> wrote:
> How does the .text.reset section get populated on the avr32 architecture?

It doesn't. Feel free to remove it from the linker script.

> As far as I can tell, there's no code in the kernel to put anything in the 
> .text.reset section, yet the linker script places that section at the 
> start of the text section.

You're right, it's a leftover from some startup code which later got
removed.

Haavard
