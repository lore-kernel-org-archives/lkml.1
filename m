Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbYBUJYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYBUJYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYBUJYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:24:11 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:11138 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYBUJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=VjqDwgstwzdl6FmNtKf19Sq1scvPavNbW5WtgCxEWk/57dZQW6qZZddbyHP5RyJPICLAimgpFb99LxFCDmxihi/pMbzjV27RyBvpoXwj34AvKa3StjFZmU08nBpqjvshWVxCI2cIV8IwQmnEiQa9++ST48qiT7kCOuehCSst/Hw=
Date: Thu, 21 Feb 2008 10:26:17 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: state of GEN_RTC vs rtc subsystem
Message-ID: <20080221092616.GA999@linux-m68k.org>
References: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B18612-66A3-476C-B81C-F2FD11CE9A64@kernel.crashing.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:11:23AM -0600, Kumar Gala wrote:
>  Is the functionality provided by drivers/char/gen_rtc.c completely handled 
>  by the rtc subsystem in drivers/rtc?

they were not designed work parallel at the same. Not sure if there is
ever a valid reason to have both comiled into one kernel image - might be
for some architectures - but when the situation is not handled correctly 
the easiest fix is to make them mutually exclusive.

Richard
