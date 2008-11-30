Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYK3PVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYK3PVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYK3PVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:21:06 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:63628 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYK3PVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UTIUf8vy6Mm+doTH3gvgNiml93ecDONcgoWYPQZolDYiGFe8y4XsNSW8xG1ZyIV9jr
         VB6n/nLbmNTXL2c5/DtF6JozDhETAK3YivdSTBnKTqwJcOG6SwW89qjobhFtbyTI7CNC
         t5Pk3pvcYlbzQUuz/g6E/AT628GAozPNZQm2k=
Date: Mon, 1 Dec 2008 00:20:56 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081201002056.d9f9204c.h.mitake@gmail.com>
In-Reply-To: <20081130092407.GA10802@elte.hu>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com>
	<20081129164736.0b5a71db.h.mitake@gmail.com>
	<20081129093858.GC26691@elte.hu>
	<20081129192610.716a2d57.h.mitake@gmail.com>
	<20081129105229.GA9643@uranus.ravnborg.org>
	<20081129222449.e341f028.h.mitake@gmail.com>
	<20081129180144.GA15533@uranus.ravnborg.org>
	<20081130171604.dc3c8715.h.mitake@gmail.com>
	<20081130083700.GA31644@elte.hu>
	<20081130092407.GA10802@elte.hu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 10:24:07 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> the 32-bit build broke promptly - readq/writeq is a family of APIs that 
> has to be either fully provided or not provided at all. The fix is below.

Thanks for your fix and adding!
When will this patch be added to mainline?
I want to rewrite x38_edac.c to adapt new APIs.
