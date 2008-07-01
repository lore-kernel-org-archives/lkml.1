Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYGAAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYGAAG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYGAAGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:06:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56128 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYGAAGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:06:14 -0400
Message-ID: <486974B4.6000108@zytor.com>
Date: Mon, 30 Jun 2008 17:05:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl>
In-Reply-To: <200807010148.02135.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Hi,
> 
> The appended patch fixes a regression and is considered as 2.6.26 material.
> Everyone having a box with working suspend to RAM is gently requested to test
> it and verify if it doesn't break things.
> 
> The patch applies to the current -git.
> 

Given the Elan report from earlier today, I'm worried this patch might 
have the same problem.  If so, it's a relatively easy change; I'll try 
to have an updated patch later this evening.

	-hpa
