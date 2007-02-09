Return-Path: <linux-kernel-owner+w=401wt.eu-S1946394AbXBIMEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946394AbXBIMEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946402AbXBIMEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:04:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:52783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946394AbXBIMEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:04:06 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Frederik Deweerdt <deweerdt@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
	<20070209105737.GF5785@slug>
	<1171020273.8675.150.camel@laptopd505.fenrus.org>
	<20070209033936.41be141b.akpm@linux-foundation.org>
From: Andi Kleen <ak@suse.de>
Date: 09 Feb 2007 14:04:02 +0100
In-Reply-To: <20070209033936.41be141b.akpm@linux-foundation.org>
Message-ID: <p73ps8j1nzx.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> As long as nobody takes the address of them (which wouldn't compile today
> anyway) then the compiler should be able to not allocate store for these. 

This would only work for unit-at-a-time compilers (if it works at all,
i'm not sure), but not older 3.x compilers

> That they're const might help too.

Don't think it does.

-Andi
