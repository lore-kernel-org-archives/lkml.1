Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYFQIVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYFQIVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFQIVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:21:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:8752 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbYFQIVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q6KmLveUhFnay5cnPu2H8R+Pyf9MXi+HTU7Z5gsrsN1p5iUpYjzdtJwVA06y29semn
         0kFAaYaZmhZOKQwQc7NcwegWkA5tbcvQqo+jEF0w7Whn0W5ub2POSKRcd2mIGMRPhgvn
         GKhty2EXbS1q5TuIltX6hNL36xUhMfmVbFb/I=
Message-ID: <45a44e480806170121s222906cdt23db2d6c394a50a1@mail.gmail.com>
Date: Tue, 17 Jun 2008 01:21:13 -0700
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Markus Armbruster" <armbru@redhat.com>
Subject: Re: "fb-defio: fix page list with concurrent processes"
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <874p7so6p7.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4856E38E.1040203@goop.org>
	 <45a44e480806161811k423fecf2r2d79609a5c0d057@mail.gmail.com>
	 <874p7so6p7.fsf@pike.pond.sub.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 12:34 AM, Markus Armbruster <armbru@redhat.com> wrote:
> "Jaya Kumar" <jayakumar.lkml@gmail.com> writes:
>
>> On Mon, Jun 16, 2008 at 3:05 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>> Your patch "fb-defio: fix page list with concurrent processes" definitely
>>> seems to help with the suspend/resume problem I had with the Xen pvfb
>>> device.  Is it queued up anywhere?  It seems to be a real bugfix, and should
>>> probably be queued for 2.6.26...
>>
>> It isn't currently queued. I had intended to improve its performance
>> by taking advantage of Andrew's suggestion of using !list_empty on the
>> page->lru to avoid walking the page list to find the duplicate page,
>> but I ran into trouble since the page starts off being on the lru
>> list. I'll try to take a look at doing this next weekend.
>>
>> Thanks,
>> jaya
>
> Well, we got a bug that makes the code useless in practice for us, and
> a fix for it that's not quite as fast as it could be.  Which is
> better, somewhat slow code, or somewhat useless code?  I'd like to see
> the fix merged as soon as possible.  You can always improve its
> performance later.
>

Ok, I didn't realize there was any time pressure. Keep in mind, I'm
just a person doing this stuff for fun on weekends not someone under
commercial pressures. Yup, I've got no problem if the old patch is
requeued and merged.

Thanks,
jaya
