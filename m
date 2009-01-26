Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZAZJiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZAZJiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZAZJh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:37:58 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:3568 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZAZJh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:37:57 -0500
Date: Mon, 26 Jan 2009 10:37:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: linux-i2c@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090126103738.1e48471a@hyperion.delvare>
In-Reply-To: <1232951630.1329.4.camel@localhost.localdomain>
References: <1231177261.13443.20.camel@localhost.localdomain>
	<20090107142426.4be04d4d@hyperion.delvare>
	<9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
	<20090107162709.755982c0@hyperion.delvare>
	<1232409577.25123.11.camel@localhost.localdomain>
	<20090120114304.3b956189@hyperion.delvare>
	<1232951630.1329.4.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 22:33:50 -0800, Ed Swierk wrote:
> Here's another attempt at a patch for rtc-ds1307 that allows the driver
> to work with SMBus controllers like nforce2 that do not support i2c
> block transfers.  The byte-oriented compatibility routines now give up
> after 10 unsuccessful attempts to read or write a block of registers
> without conflict.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

Looks alright to me this time.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
