Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZBTP25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZBTP25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBTP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:28:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:39856 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBTP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <ac3eb2510902191508w71cf7d76x4a8957ecee9c4e6@mail.gmail.com>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <fa686aa40902180748i2d621de1j1da7600e8cc3165f@mail.gmail.com>
	 <ac3eb2510902180753l5dc94e5dje9154eaea9d2db29@mail.gmail.com>
	 <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com>
	 <ac3eb2510902180849o6d86bbfev337e1bc203d6543e@mail.gmail.com>
	 <fa686aa40902180951q64c71581y3811062256685df7@mail.gmail.com>
	 <ac3eb2510902181032h3f9ed994s212dd8b42ddca82@mail.gmail.com>
	 <20090218183945.GA31797@suse.de>
	 <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com>
	 <ac3eb2510902191508w71cf7d76x4a8957ecee9c4e6@mail.gmail.com>
Date: Fri, 20 Feb 2009 08:28:42 -0700
Message-ID: <fa686aa40902200728k1466121cqb772bb9e5d1a777c@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Grant Likely <grant.likely@secretlab.ca>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Thanks for the reply, it clarifies a lot.  It sounds like this really
should be documented (in Documentation/driver-model/device.txt?).  I'm
happy to add a blurb to that effect and send a patch, but I want to
make sure I really understand the model before I do so.  I've got a
couple more questions below:

On Thu, Feb 19, 2009 at 4:08 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
[...]
> If an attribute is not available at event time, nothing of this can
> ever work. If you look a the device a second later, you will see the
> proper looking files and values, and all the test programs will work,
> but it will always fail at device creation.
[...]
> That all might not be needed for your specific setup/driver/device and
> may work fine for your need. But we don't want to encourage anybody
> with another new API which creates the usual trouble we need to fix
> later.

Fair enough

> And we need to fix things like this all the time.

Can you point me at a 'textbook' example of one of these fixups?

> Also the existing sysfs attribute groups API has the same problem if
> the group is created later, but as far as I can see it should work
> fine for your purpose. So it's better using that, instead of exporting
> another different API.

Okay, I this option looks pretty straight forward too.

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
