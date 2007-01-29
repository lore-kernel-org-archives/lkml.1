Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXA2Qzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXA2Qzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbXA2Qzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:55:49 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:45340 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXA2Qzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:55:48 -0500
Message-ID: <45BE2709.4050209@gmail.com>
Date: Mon, 29 Jan 2007 17:55:37 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: akpm@osdl.org
CC: ak@suse.de, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Murray <murrayma@citi.umich.edu>
Subject: Re: [PATCH] x86_64: sync up probe_roms() with i386
References: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net> <45BDFAB5.40606@gmail.com>
In-Reply-To: <45BDFAB5.40606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2007 02:46 PM, Rene Herman wrote:

> This syncs up the x86_64 probe_roms() with the i386 version as just 
> submitted.
> 
> ===
> Sync up with i386. Specifically, be careful about touching the
> legacy ROMs; in virtualized environments they may not be mapped.
> 
> Crosscompiled, but not booted due to lack of hardware.
> 
> Signed-off-by: Rene Herman <rene.herman@gmail.com>
> ===

In the meantime tested by Martin Murray on x86_64 native and inside 
vmware (thanks much!) who told me I could add his sob:

Signed-off-by:  Martin Murray <murrayma@citi.umich.edu>

Rene.
