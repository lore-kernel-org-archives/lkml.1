Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbZKYRX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbZKYRX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbZKYRX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:23:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbZKYRXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:23:13 -0500
Date: 25 Nov 2009 18:20:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: khc@pm.waw.pl
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDZb9P9ZjFB@christoph>
In-Reply-To: <m3fx827dgi.fsf@intrepid.localdomain>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+nKdFVEa+JUCYwIWqS6mFuSiuQRlBisqz9RYK
 WVyMyIneBnDpbQq6TC4frPkDgToK+EhIP5MiKOlx0FxV16e9VN
 EYHNo28HTH93w5YqplMV2czI0jdNiY/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 25 Nov 09 at 17:53, Krzysztof Halasa wrote:
> Jarod Wilson <jarod@wilsonet.com> writes:
[...]
>> nimble. If we can come up with a shiny new way that raw IR can be
>> passed out through an input device, I'm pretty sure lirc userspace can
>> be adapted to handle that.

As Trent already pointed out, adding support for raw IR through an input  
device would require a new interface too. You just put the label "input  
device" on it. This does not make much sense for me.

> Lirc can already handle input layer. Since both ways require userspace
> changes,

I'm not sure what two ways you are talking about. With the patches posted  
by Jarod, nothing has to be changed in userspace.
Everything works, no code needs to be written and tested, everybody is  
happy.

We had exactly the same discussion around one year ago. I've seen no new  
arguements in the current discussion and nobody came up with this shiny  
new way of integrating LIRC into the input layer since last year. Maybe  
it's about time to just accept that the LIRC interface is the way to go.

Can we finally get the patch integrated, please?

Christoph
