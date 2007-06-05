Return-Path: <linux-kernel-owner+w=401wt.eu-S1764261AbXFEJqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764261AbXFEJqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763612AbXFEJq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:46:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52248 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763234AbXFEJq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:46:26 -0400
Date: Tue, 5 Jun 2007 11:46:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070605094623.GA23274@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan> <20070604201823.7b7cb328@the-village.bc.nu> <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com> <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com> <m1ejkrw576.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejkrw576.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So the only safe thing we can do is not use memory that is not
> write-back cached.  That we can positively detect and is a
> conservative action so if anything will work that will.

Jesse wrote such a patch (or rather it limitted end_pfn), but it broke
the X server for so far unknown reasons.

-Andi
