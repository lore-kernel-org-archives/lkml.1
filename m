Return-Path: <linux-kernel-owner+w=401wt.eu-S934254AbZJMUHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254AbZJMUHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760478AbZJMUHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:07:47 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32817 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZJMUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:07:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 3/9] vsprintf: add %pR decoding and %pr for raw struct resource
Date: Tue, 13 Oct 2009 14:07:07 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>, Len Brown <lenb@kernel.org>
References: <20091013192040.22336.84876.stgit@bob.kio> <20091013192210.22336.28703.stgit@bob.kio> <1255462808.18975.70.camel@Joe-Laptop.home>
In-Reply-To: <1255462808.18975.70.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131407.08290.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009 01:40:08 pm Joe Perches wrote:
> On Tue, 2009-10-13 at 13:22 -0600, Bjorn Helgaas wrote:
> > This adds support for printing struct resource type and flag information.
> > For example, "%pR" looks like "[mem 0xf5df0000-0xf5df3fff 64bit pref]",
> > and "%pr" looks like "[mem 0xff5e2000-0xff5e2007 flags 0x201]".
> 
> %p[A-Za-z0-9] is a relatively limited resource.
> 
> Isn't it better to avoid using multiple characters
> for a single type?

I followed the example of F/f, S/s, M/m, etc.  I could
easily go back to %pR/%pRf or something, but I don't know
if it's worth the trouble.

Bjorn
