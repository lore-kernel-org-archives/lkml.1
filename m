Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYI3CAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYI3CAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYI3CAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:00:01 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:25911 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYI3CAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LsvfjIMEJyKlTaIJapainHxLRo0j49OP7PS+MW5wbN/JO4eKBwhCUxflFiDL6g+ExW
         3Bt1s209gd7+kQxrQxV5VyTjdXUqwKW75NGHYtTX26zx48BD37X8BsjXu3iXXWQnhSLr
         lbcVfRwje5CU1nIxjXb8uukYVyB0gbjso9RV0=
Message-ID: <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
Date: Tue, 30 Sep 2008 11:59:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc8
Cc: "Jiri Kosina" <jkosina@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
In-Reply-To: <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	 <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	 <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 11:56 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 30 Sep 2008, Jiri Kosina wrote:
>>
>> Intel is working with us on tracking down and resolving the issue, but
>> this is not going as well as one would like to see (one attempt, one card
>> with completely hosed EEPROM contents ... and restoring the contents is
>> not *that* trivial).
>
> What's the magic to trigger it? I've got a laptop with that e1000e chip in
> it, and am obviously running a recent kernel on it. Do people have a
> handle on it? Is it actually verified to be kernel-related, and not
> related to the X server etc?

If we had the magic we'd have fixed it by now, the current working
theory is its X server related. This
hasn't been proven, though my ATI GPU e1000e seems fine so it may have
some legs.

If it is X related then its both a kernel + X server issue, the e1000e
driver opens the barn door, the X server drives the horses through it.

Of course until someone produces a way to fix the hw after it breaks,
reproducing this isn't something for the feint hearted. I'm hoping my
laptop
comes back today with a brand new motherboard in it.

Dave.
