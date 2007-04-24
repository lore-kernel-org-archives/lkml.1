Return-Path: <linux-kernel-owner+w=401wt.eu-S1423078AbXDXUBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423078AbXDXUBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423086AbXDXUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:01:14 -0400
Received: from gw.goop.org ([64.81.55.164]:53718 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423080AbXDXUBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:01:12 -0400
Message-ID: <462E6222.3060302@goop.org>
Date: Tue, 24 Apr 2007 13:01:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@suse.de>
Subject: Re: [PATCH 16/25] xen: Use the hvc console infrastructure for Xen
 console
References: <20070423215638.563901986@goop.org> <20070423215712.328111104@goop.org> <20070424012111.GA28649@lixom.net>
In-Reply-To: <20070424012111.GA28649@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> On Mon, Apr 23, 2007 at 02:56:54PM -0700, Jeremy Fitzhardinge wrote:
>   
>> Implement a Xen back-end for hvc console.
>>
>> From: Gerd Hoffmann <kraxel@suse.de>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>>
>> ---
>>  arch/i386/xen/Kconfig     |    1 
>>  arch/i386/xen/events.c    |    3 -
>>  drivers/Makefile          |    3 +
>>  drivers/xen/Makefile      |    1 
>>  drivers/xen/hvc-console.c |  134 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/xen/events.h      |    1 
>>  6 files changed, 142 insertions(+), 1 deletion(-)
>>     
>
> If you move the driver to drivers/char/hvc_xen.c instead, you won't have to do...
>
>   
>> +#include "../char/hvc_console.h"
>>     
>
> ...this.
>
> Other single-platform backend hvc drivers are under drivers/char already.

Good point.

    J
