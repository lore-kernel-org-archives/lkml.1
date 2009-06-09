Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZFISRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZFISRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZFISRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:17:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZFISRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:17:44 -0400
Message-ID: <4A2EA719.2000608@zytor.com>
Date: Tue, 09 Jun 2009 11:16:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
References: <1243865115.24278.8.camel@nathan.suse.cz> <1244215559.1604.12.camel@nathan.suse.cz> <20090605200701.GB23195@uranus.ravnborg.org> <1244532418.5199.24.camel@nathan.suse.cz> <20090609181157.GA7181@uranus.ravnborg.org>
In-Reply-To: <20090609181157.GA7181@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>
>>> Why do we need *(.data .data.*) rather than *(.data*)?
>>> *(.dynbss*)?
>> I don't have any strong opinion here, but the former is exactly what the
>> default linker script has.
> 
> My general take on this is that we should know and deal with what the linker produces.
> So if we only expect .data then .data.* could go into .broken so we catch it. 
> 

That will break if we change to per-function sections.

	-hpa
