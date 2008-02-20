Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbYBTRiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbYBTRiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYBTRh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:37:58 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:24249 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYBTRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vi16lifPQwL5GXMH13iVYZnt+tb7//3gU8c0TSQHv2CGvSpalWuSwWahTTc16VU3u+qwerlfZw1xSJX8O+UBMJJni7IcUB0LYKYmulfg0kvXvBpfJuYBtleXNQcEZVMmRXI0Zlxv19YncuNtAeM4uky9IS7fbjWFQ3LoA3Fv4Nk=
Message-ID: <b6a2187b0802200937q3ff8f470k235b5d1e00eab59e@mail.gmail.com>
Date: Thu, 21 Feb 2008 01:37:53 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21, 2008 1:28 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Try suspend-and-resume without X.

Works without those two functions.

> Also, try it on one of the more modern laptops - even *with* X.

Again, still works. Tested on Lenovo X60s.

> Basically, the kernel wants to be able to do what X does, because it means
> that when it works, it works _so_ much better than doing it in X. So
> getting it working is definitely worth it.

> That said, before you do anything else, try if suspend-to-RAM works.

Yes, still works.

> That's the primary goal for this code anyway, and if it works that gives a
> good hint.

Ok, what's next?

Thanks,
Jeff.
