Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXFLO6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXFLO6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXFLO57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:57:59 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:42282 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753426AbXFLO57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:57:59 -0400
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
From: Paul Albrecht <albrecht@rdi1.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200706120114.48645.dtor@insightbb.com>
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com>
	 <1181588095.2436.5.camel@albrecht.rdi1.com>
	 <200706120114.48645.dtor@insightbb.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jun 2007 10:02:26 -0400
Message-Id: <1181656946.3176.1.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 01:14 -0400, Dmitry Torokhov wrote: 
> On Monday 11 June 2007 14:54, Paul Albrecht wrote:
> > 
> > Is i8042.noaux a workaround or a fix?
> > 
> 
> Just a workaround. Do you have a PS/2 mouse you could test with? If so could
> you check if both keybioard and mouse work with mouse plugged in and without
> i8042.noaux.
> 

The system I'm using has only one ps/2 interface so I can't test with
them both plugged in at the same time.

> Also cxould you please try the patch below (again with mouse if you have one
> and without).
> 

I tried applying your patch to 2.6.21.5 and it failed. Here's the
output:

patch --dry-run -p1 < ../i8042.patch
patching file drivers/input/serio/i8042-x86ia64io.h
Hunk #1 FAILED at 356.
Hunk #2 FAILED at 404.
2 out of 2 hunks FAILED -- saving rejects to file
drivers/input/serio/i8042-x86ia64io.h.rej



Paul Albrecht

