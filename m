Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbYBGWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbYBGWpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbYBGWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:45:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbYBGWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:45:07 -0500
Message-ID: <47AB89CB.7010908@zytor.com>
Date: Thu, 07 Feb 2008 14:44:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <20080207222845.GA6096@elf.ucw.cz> <200802072340.06138.rjw@sisk.pl>
In-Reply-To: <200802072340.06138.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> -	rep; stosl
> +	rep
> +	stosl

Yuck!

Please don't perpetuate the braindamage that this is two instructions. 
It's one instruction with a modifier; the fact that gas wants a 
separator is broken enough as it is.

	-hpa
