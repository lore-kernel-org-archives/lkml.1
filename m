Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYAHXtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYAHXtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYAHXtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:49:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34587 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYAHXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:49:45 -0500
Date: Wed, 9 Jan 2008 00:52:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080108235212.GE2117@one.firstfloor.org>
References: <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com> <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com> <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com> <20080102215433.GB13784@one.firstfloor.org> <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com> <20080104222637.GA19248@one.firstfloor.org> <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com> <20080105132402.GA705@one.firstfloor.org> <3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com> <3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  ENTRY(thermal_interrupt)
> -	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
> +	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt(%rip)

Are you sure a * is not needed?  I would have thought it would jump
to the variable instead of through it. But if it works it's ok for me.

The rest of the patch looks ok to to me.

-Andi

