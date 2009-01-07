Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZAGPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZAGPne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbZAGPnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:43:21 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:49847 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZAGPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:43:19 -0500
Message-ID: <9ae48b020901070743x1a5eaf72k5314cd969dc580ef@mail.gmail.com>
Date: Wed, 7 Jan 2009 07:43:18 -0800
From: "Ed Swierk" <eswierk@aristanetworks.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Cc: linux-i2c@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "Alessandro Zummo" <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "BARRE Sebastien" <sbarre@sdelcc.com>
In-Reply-To: <20090107162709.755982c0@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231177261.13443.20.camel@localhost.localdomain>
	 <20090107142426.4be04d4d@hyperion.delvare>
	 <9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
	 <20090107162709.755982c0@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 7:27 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Did you try 0x4a (as i2c-amd8111 is using)?

Yes, it returns an error, as do all the other unsupported commands.

> So, you have the datasheet... Is this something you would be allowed to
> share with me?

Unfortunately not; we acquired it under an NDA.

>> I could change the ds1307 driver to check whether the controller
>> supports i2c block commands and fall back to emulation only if they
>> are not available. Would that address your concerns?
>
> Yes, that would. Same thing the eeprom or lm93 drivers are doing, to
> only name a few of them. Should be fairly easy.

OK, will do.

--Ed
