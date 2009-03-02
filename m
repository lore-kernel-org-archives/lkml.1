Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZCBAun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZCBAun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 19:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZCBAua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 19:50:30 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:46158 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZCBAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 19:50:30 -0500
Date: Mon, 2 Mar 2009 01:50:24 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
Message-ID: <20090302005024.GA3223@buzzloop.caiaq.de>
References: <20090301132953.GF20813@buzzloop.caiaq.de> <49AAE73D.1010707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AAE73D.1010707@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 01:51:25PM -0600, Robert Hancock wrote:
>> are there any plans to free the lis3 driver from its ACPI dependency?
>> In fact, this device is I2C/SPI connected which the ACPI layer seems to
>> hide from the driver, but to use it on embedded devices, the bus drivers
>> must be used directly and the dependeny seems entirely unnecessary
>> anyway.
>
> If ACPI AML code attempts to access the device (which it obviously does,  
>  since we're presumably using the same code to access it), then we  
> cannot be accessing it directly at the same time, otherwise the two will  
> stomp on each other.

It's not about accessing the same device in more than one way one one
particular platform but about keeping the driver abstract enough so it
can be hooked up to different bus types. At the moment, it isn't
completely seperated from ACPI, that's why I'm asking.

Daniel
