Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYJPU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYJPU65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYJPU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:58:49 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:24733 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYJPU6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:58:48 -0400
Message-ID: <48F7AB05.50103@msgid.tls.msk.ru>
Date: Fri, 17 Oct 2008 00:58:45 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.1: install conflict about /lib/firmware
References: <48F78C5C.8080907@t-online.de>
In-Reply-To: <48F78C5C.8080907@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi folks,
> 
> Seems that there is an installation conflict about
> /lib/firmware/ess/maestro3_assp_kernel.fw (and probably
> others) between 2.6.27 and 2.6.27.1. Using dpkg I get

Since 2.6.27, firmware binaries are placed into /lib/firmware
directory.  The reason is that firmware is not kernel-dependent.
Or, rather, the firmware stored here is not kernel-dependent
(when it is, it's stored in /lib/modules/$version/).

[]
> Probably other package managers get a similar problem.

A package build script should be updated to create separate
package with the firmware, and to add proper reguiriments
and/or dependencies.

> Wouldn't it be more consistent to put the firmware files in a
> kernel specific directory, e.g. in /lib/firmware/2.6.27.1 or
> /lib/modules/2.6.27.1/firmware ?

No, because the firmware is not kernel-dependent, but device-dependent.
It were deliberate choice.

/mjt
