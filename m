Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZJMUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZJMUck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZJMUci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:32:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2106 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZJMUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:32:37 -0400
Subject: Re: [PATCH v2 3/9] vsprintf: add %pR decoding and %pr for raw
 struct resource
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Len Brown <lenb@kernel.org>
In-Reply-To: <200910131407.08290.bjorn.helgaas@hp.com>
References: <20091013192040.22336.84876.stgit@bob.kio>
	 <20091013192210.22336.28703.stgit@bob.kio>
	 <1255462808.18975.70.camel@Joe-Laptop.home>
	 <200910131407.08290.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 13:32:00 -0700
Message-Id: <1255465920.18975.72.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 14:07 -0600, Bjorn Helgaas wrote:
> On Tuesday 13 October 2009 01:40:08 pm Joe Perches wrote:
> > On Tue, 2009-10-13 at 13:22 -0600, Bjorn Helgaas wrote:
> > > This adds support for printing struct resource type and flag information.
> > > For example, "%pR" looks like "[mem 0xf5df0000-0xf5df3fff 64bit pref]",
> > > and "%pr" looks like "[mem 0xff5e2000-0xff5e2007 flags 0x201]".
> > Isn't it better to avoid using multiple characters
> > for a single type?
> I followed the example of F/f, S/s, M/m, etc.  I could
> easily go back to %pR/%pRf or something, but I don't know
> if it's worth the trouble.

I'd prefer %pR and %pRr for raw, but maybe that's just me.

cheers, Joe

