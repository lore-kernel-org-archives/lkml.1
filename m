Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYE0QHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYE0QHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYE0QG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:06:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:42369 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbYE0QG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CC4xFGS9sgMTHYPGUo61fEPunkNIUuqZtBnWxrp6vDxCK8uaUs9E4PcbCWjfK17Teh6hilYflvDzWbxbTWHWaiKGXM/7lMusWB/dIBbPioWAn3jGxjmNpRyNIAH5LbNvIqPe7jwSjxIJPT34Zx/4giKpAsAymBsKvVSG6hv5X8g=
Message-ID: <2f11576a0805270906x35a1f15eu7fe7414bbfe5c4b4@mail.gmail.com>
Date: Wed, 28 May 2008 01:06:55 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: apw@shadowen.org
Subject: Re: [PATCH 2/3] slub: record page flag overlays explicitly
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@osdl.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080527145250.GA3407@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <exportbomb.1211560342@pinky> <1211560402.0@pinky>
	 <20080526133755.4664.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080527145250.GA3407@shadowen.org>
X-Google-Sender-Auth: 25adfae9fa3441e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > -           if (SlabDebug(page))
>> > -                   printk(KERN_ERR "SLUB %s: SlabDebug set on "
>> > +           if (PageSlubDebug(page))
>> > +                   printk(KERN_ERR "SLUB %s: SlubDebug set on "
>> >                             "slab 0x%p\n", s->name, page);
>> >     }
>> >  }
>>
>> Why if(SLABDEBUG) check is unnecessary?
>
> They were unconditional before as well.  SlabDebug would always return
> 0 before the patch.  The point being, to my reading, that if you asked
> for debug on the slab and debug was not compiled in you would still get
> told that it was not set; which it cannot without the support.

Thank you explain!

  Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
