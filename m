Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYGRBtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYGRBtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYGRBtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:49:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7262 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYGRBtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:49:24 -0400
Date: Thu, 17 Jul 2008 19:48:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Does 2.6.26 provide nanosecond time to the user?
In-reply-to: <fa.cG/vRVVC+ZH1htzxsRnVF3NJVCc@ifi.uio.no>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <487FF67B.2050801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.cG/vRVVC+ZH1htzxsRnVF3NJVCc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens wrote:
> Im confused.
> (sorry I havent been following the linux-kernel mailing list on this)
> 
> Does 2.6.26 use nanosecond time
>     (1) internally?
>     (2) provide it to the user?
> 
> I see no way to turn it on/off in xconfig.
> Yet I do see STA_NANO defined in sys/timex.h which is a good start.
> 
> and IF it provides it to the user, what do I use to get nanosecond time.
> My search with man -k for timespec turns up
>       sys_clock_getres
> and sys_clock_gettime
> 
> or possibly clock_getres and clock_gettime, the man pages use both,
> but NONE of these entry points seem to exist in my system.
> 
> Puzzled.

clock_gettime should exist. Old glibc version?
