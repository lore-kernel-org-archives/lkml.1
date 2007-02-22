Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbXBVStu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbXBVStu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXBVSts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:49:48 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbXBVStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:49:47 -0500
Message-ID: <45DDE56C.7060704@zytor.com>
Date: Thu, 22 Feb 2007 10:48:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de> <45DDC810.3000401@zytor.com> <45DDD538.1040309@goop.org> <20070222183628.GA65601@muc.de>
In-Reply-To: <20070222183628.GA65601@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Feb 22, 2007 at 09:39:04AM -0800, Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> Sometimes returning small structures is really nice.  If you can pass
>>> them in registers, it's often generates the fastest possible code;
>>> much better than using a pointer. 
>> Yes, but specifically, are there any pieces of assembler which return
>> structures?  It appears there are none (since Ingo got a booting
>> kernel), but there might be something obscure in some corner.
> 
> When I did the x86-64 port I went over all assembler and I can't remember
> anything that did that. Of course there might be out of tree drivers
> that do, but they just have to fix it up.
> 
> BTW would it make sense to have a special announcement list for such changes?
> 

To some degree linux-arch would be a good list for it, but it's closed, 
even to monitor.

	-hpa
