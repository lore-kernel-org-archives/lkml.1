Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXFBUjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXFBUjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 16:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbXFBUjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 16:39:23 -0400
Received: from n4.bullet.mail.re4.yahoo.com ([206.190.56.23]:21943 "HELO
	n4.bullet.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754760AbXFBUjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 16:39:23 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 372206.49494.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=uho6KDGKL84JSbuwo+NvZj4yZNtWHGQUQSNa9+gVN1IvJ3FgAT533rWZn5bCqW2r9tvf7OYsz92mxMrcSD6/UtVf8BuZdLU+AttizUCpy8A3Y+WHhMgYT3aIydrwtej2KRAYfJqmmOj3HR5t3BCko4PCKC3yyzGsJGqVzAYCEYs=;
X-YMail-OSG: Z9iPEswVM1mwr8QRzwB_5w6LL3BYN5i69eNOsdUfzzv52h5Jmm7zFDjb59nQr0oI.Aga8oygGNY3sOO7S99Y.zsU7Emh7pZYCNkS
Date: Sat, 2 Jun 2007 13:39:21 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
To: Len Brown <lenb@kernel.org>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200706021346.57067.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <186376.4823.qm@web63604.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Len Brown <lenb@kernel.org> wrote:

> > +static int __init disable_blacklisted_ioapic(struct dmi_system_id *d)
> > +{
> > +	printk(KERN_WARNING "%s detected... Disabling IO-APIC\n", d->ident);
> > +	skip_ioapic_setup = 1;
> > +	return(0);
> > +}
> 
> Wouldn't this also disable the IOAPIC in the (working) ACPI+IOAPIC case?

Yes, it would. However, I wanted to make my addition
to the kernel generic so that other people with
problematic IO-APIC implementations can blacklist
their systems without checking whether ACPI is enabled
or not.

Thank you for your question/attention.

Regards,
- Tear



       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC

