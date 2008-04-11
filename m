Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbYDKKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbYDKKfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbYDKKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:35:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36304 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147AbYDKKfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:35:31 -0400
Subject: Re: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for
	interrupt routing"
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080411062928.GB4748@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	 <20080411062928.GB4748@martell.zuzino.mipt.ru>
Date: Fri, 11 Apr 2008 13:35:28 +0300
Message-Id: <1207910128.7212.4.camel@haji>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 10:29 +0400, Alexey Dobriyan wrote:
> On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
> > - git-slub has been temporarily replaced by git-pekka.  Pekka is standing in
> >   while Christoph is away.
> 
> I bisected boot hang after "ACPI: using IOAPIC for interrupt routing"
> down to git-pekka.
> 
> normal dmesg from 2.6.25-rc8-something and .config snippets for -mm

Alexey, can you try passing the 'slub_nomerge' option to the kernel to
see if the hang goes away with that?

			Pekka

