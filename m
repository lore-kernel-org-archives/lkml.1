Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYBQCbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYBQCbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYBQCbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:31:40 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:45823 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYBQCbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:31:39 -0500
Message-ID: <47B79D0D.2070808@keyaccess.nl>
Date: Sun, 17 Feb 2008 03:33:49 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace
 !likely(x) by likely(!x)
References: <47B70810.5030608@tiscali.nl> <47B732EF.4050504@zytor.com>
In-Reply-To: <47B732EF.4050504@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-02-08 20:01, H. Peter Anvin wrote:
> Roel Kluin wrote:
>> Not entirely sure who to send this to
>> ---
>> Replace !likely(x) by likely(!x)
> 
> Whoa...
> 
> Are you sure this is correct?
> 
> !likely(x) is equivalent to unlikely(!x)

Not with respect to its value I believe? likely(x) == !!(x), and 
unlikely(!x) == !!(!x) = !x, so conditions work out differently?

> not the opposite, so this is a functional change...

Rene.
