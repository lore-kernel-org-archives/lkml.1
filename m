Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbXBVIa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbXBVIa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXBVIa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:30:29 -0500
Received: from gw.goop.org ([64.81.55.164]:40277 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbXBVIa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:30:28 -0500
Message-ID: <45DD54A7.2010100@goop.org>
Date: Thu, 22 Feb 2007 00:30:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org>	 <1172131463.3531.226.camel@laptopd505.fenrus.org>	 <45DD4FA0.5030205@goop.org> <1172132103.3531.228.camel@laptopd505.fenrus.org>
In-Reply-To: <1172132103.3531.228.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> Do we have much assembler which cares about the struct return calling
>> convention?  If not, it should be a fairly easy test.
>>     
>
> is there an attribute to turn it off? because if so we should just make
> that part of "asmlinkage".... (not that I know much code using structs
> in asm)
>   

There doesn't appear to be; just -freg-struct-return and
-fpcc-struct-return.

    J
