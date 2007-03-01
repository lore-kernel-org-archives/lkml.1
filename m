Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbXCADrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbXCADrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 22:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXCADrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 22:47:14 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:47485 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXCADrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 22:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=slVyG7xZLUC1pPJ0VueeVZ089tPwcIyog4ysdY98zRgmVI6vvxOChCKLj98XgyAA0n6goAPY+IyIW26KjnZbixQc3+QmWRaX9+tP/ugEDhcj9TWc0c26JNlN6X2ZvpsNGDzjDdVg6IvDr7p0IE8IG6tbfR515jgedfm95w1PIvI=
Message-ID: <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
Date: Thu, 1 Mar 2007 11:45:35 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       "Ingo Molnar" <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070228211318.GB4301@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <20070226220152.GA29575@stusta.de>
	 <20070228211318.GB4301@mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> with 2.6.20, pressing Fn/F4 generates an ACPI event and triggers suspend to RAM.
>
> On 2.6.21-rc2, after resume (when the box is accessible from network),
> pressing Fn/F4 again does not seem to have any effect.

I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
from RAM, can't suspend to disk. It is possible to revert all the
changes to ACPI and test it?

Jeff.
