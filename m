Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXLLUFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXLLUFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXLLUFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:05:10 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:20074 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXLLUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TH4B0+v8ZN+Mw9B2hj39IeSJqGhVUwtyUmak2Y0uYOmjZyH3FcjzhK5KY4LJHiwBDFlGrvAMNSndQz2ixTpBFF8dhO+MewSJ2cLNoc3EaA9JYSe9TNbk+NnKAHjJCtRa+P37KM6wS8JAAgpl3uRXGTnsIEwz052wwsBG03990cs=
Message-ID: <3efb10970712121205s7fcda39dt7cfa154c53f3eecb@mail.gmail.com>
Date: Wed, 12 Dec 2007 21:05:06 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] Revert Softdisable for simple irqs.
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
	 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
	 <1196176294.13982.58.camel@localhost.localdomain>
	 <1196177122.23808.7.camel@imap.mvista.com>
	 <1196178834.23808.11.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
X-Google-Sender-Auth: c76692a7b36ac734
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

>
> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
> was implemented, and the simple irq handler had a masking set to it.
>
> Remy Bohmer discovered that some devices in the ARM architecture
> would trigger the mask, but never unmask it. His patch to do the
> unmasking was questioned by Russell King about masking simple irqs
> to begin with. Looking further, it was discovered that the problems
> Remy was seeing was due to improper use of the simple handler by
> devices, and he later submitted patches to fix those. But the issue
> that was uncovered was that the simple handler should never mask.
>
> This patch reverts the masking in the simple handler.

Also:
Acked-by: Remy Bohmer <linux@bohmer.net>

Thanks for the effort also, I still had it on my todo list, but that
is needed anymore...

Remy
