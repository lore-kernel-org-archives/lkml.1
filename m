Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYKFLSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYKFLSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYKFLSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:18:36 -0500
Received: from ozlabs.org ([203.10.76.45]:37570 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbYKFLSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:18:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: virtio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Thu, 6 Nov 2008 22:18:36 +1100
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
References: <1225393822.21973.39.camel@nga.site> <200811061445.12050.rusty@rustcorp.com.au> <ac3eb2510811052228o305b432cp2df9d311f103fc92@mail.gmail.com>
In-Reply-To: <ac3eb2510811052228o305b432cp2df9d311f103fc92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811062218.37128.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2008 17:28:56 Kay Sievers wrote:
> On Thu, Nov 6, 2008 at 04:45, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I'm curious how you're going to handle out-of-memory conditions?
>
> If the name can't be set, the following call to device_register() will
> fail, and should be handled by the caller. Just like today when we
> allocate the kobject name in device_register(). After the core has
> switched over, the name allocation will only happen a few lines
> earlier, it should not behave different otherwise. Is that what you
> mean?

Yep, thanks.  Sounds fine.

Rusty.
