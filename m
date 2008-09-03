Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYICIzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYICIzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYICIzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:55:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:37291 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYICIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XuS7ml/IJchaDn3OoUzjUcDV2W2B48JavmsAfNi4ltjqw8Dx24JeeCYkioxoCgV8EF
         UXnnEm6TdpBUYP5rgONn/3KAWcBlnVkC1qRXxLdLCb92cK9yHOEz40dJrSGWGp+vxfdv
         6w/g4XKp7aweZl/fAbHI/t1QSQ1B1X/mAgEAw=
Message-ID: <68676e00809030154i7470b08o770198bbefe00924@mail.gmail.com>
Date: Wed, 3 Sep 2008 10:54:59 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [2.6.27] early exception - lockdep related?
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <1220431061.8609.87.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080902210646.GA10925@dreamland.darkstar.lan>
	 <1220424721.8609.74.camel@twins>
	 <68676e00809030128o45820023n6f270847e14af2a3@mail.gmail.com>
	 <1220431061.8609.87.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 10:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2008-09-03 at 10:28 +0200, Luca Tettamanti wrote:
>> On Wed, Sep 3, 2008 at 8:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2008-09-02 at 23:06 +0200, Luca Tettamanti wrote:
>> >> Hello,
>> >> I'm seeing an early exception (0e) - which seems related to lockdep - at
>> >> boot with many 2.6.27 kernels and I'm having troubles to track it down.
>> >
>> > Does it print one of these nice stack traces?
>>
>> Of course not ;-) It dies before dumping the stack trace (or at least
>> it doesn't make to the console - that machine has a serial port, but
>> my notebook does not... I've ordered a usb-to-serial adapter).
>
> Until it arrives, you could try poking at netconsole..

Hum, I forgot to mention that it dies very early, just after:

Kernel is alive
Kernel is really alive
<exception>
<dead>

Is netconsole already up at that point?

Luca
