Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYI3CjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYI3CjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYI3CjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:39:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:64010 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYI3CjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wmkysycc7lSLsYEBK/f1xgrUn3V/ywu8juKuQatFmUxhcvSzWM2V3Sl3iXPmlweLe2
         gi7tFh55myDs0hvl5+6/aM6sidoIY4gLwozfS881j+vZHyYT3tYVpaBZrjzQsL07Fqek
         d0pqE+Obfq5Y3s2MqIIgkPSKEba+Cqi4Bfzis=
Message-ID: <21d7e9970809291939r51a728c8ye865e19dffac5bd6@mail.gmail.com>
Date: Tue, 30 Sep 2008 12:39:03 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc8
Cc: "Jiri Kosina" <jkosina@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
In-Reply-To: <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
	 <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
	 <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
	 <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
	 <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 12:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 30 Sep 2008, Dave Airlie wrote:
>>
>> If it is X related then its both a kernel + X server issue, the e1000e
>> driver opens the barn door, the X server drives the horses through it.
>
> Are you sure? There was a mandriva report abou NVM corruption on an e100
> too (that one apparently just caused PXE failure, the networking worked
> fine).

Well from a purely empirical standpoint, I've been running new X
against that laptop for a long time,
and others have the same laptop, so I think its a problem with the
e1000e driver putting the card into a state which allows
X to do bad things. I think X maybe causing issues on other hw, like
e100 and some realtek.. Also when we say X I think it looks like Intel
driver interaction issues,
as I said I'm running the same stuff on my ATI gpu laptop with e1000e
and haven't had any problems.

But I'm leaving this up to Intel, I don't think HP will take it too
kindly if I keep returning my laptop.

Dave.
