Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZFSRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZFSRrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZFSRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:47:10 -0400
Received: from mail-qy0-f175.google.com ([209.85.221.175]:58905 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZFSRrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:47:08 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 13:47:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUDoWrlncN2Hz4oXWBA3Upd2t7va9FCmmzOtqeKoQ7XA7YaJiFIB839AGw9RgrZS2E
         qQeru25TxRA8WtYTCVPWoQ0H525xZwiROl3CVGETJoSA4TaBdDu5H2JvQ/Vql6wETZEK
         7s5kdmj9qiUYHH4277kXtz1I9UnJtHNPyL6dM=
MIME-Version: 1.0
In-Reply-To: <20090511031208.GA15208@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com>
	 <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
	 <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
	 <20090511031208.GA15208@dtor-d630.eng.vmware.com>
Date: Fri, 19 Jun 2009 23:08:57 +0530
Message-ID: <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
From: Trilok Soni <soni.trilok@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kim Kyuwon <chammoru@gmail.com>, Kim Kyuwon <q1.kim@samsung.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 11, 2009 at 8:42 AM, Dmitry
Torokhov<dmitry.torokhov@gmail.com> wrote:
> On Mon, May 11, 2009 at 11:34:54AM +0900, Kim Kyuwon wrote:
>> Hi Trilok,
>>
>> On Sun, May 10, 2009 at 2:27 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> > Hi Kim,
>> >
>> > On Sat, May 9, 2009 at 7:39 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
>> >> The Maxim MAX7359 is a I2C interfaced key switch controller which provides
>> >> microprocessors with management of up to 64 key switches.
>> >> This patch adds support for the MAX7359 key switch controller.
>> >>
>> >> Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
>> >
>> >
>> > Thanks for implementing review comments. Please add
>> >
>> > Reviewed-by: Trilok Soni <soni.trilok@gmail.com>
>>
>> Sorry, I didn't know I should put the "Reviewed-by" in the reviewed
>> patch.(I'm still kernelnewbie :) )
>
> You are not supposed to add it until somebody explicitely asks you to
> do that, same with Acked-by... The reason is that these tags constitute
> certain endorsement of the patch and while one person may review the
> patch he/she may not yet feel that review process is complete. Hope this
> makes some sense...
>
>> If possible, I want Dmitry to add
>> "Reviewed-by" when he sends this driver to mainline, or I will send
>> new patch again.
>>
>
> I have it added to my copy.

I was looking at Palm Pre released linux-2.6.24 patch today at their
site http://palm.cdnetworks.net/opensource/1.0.1/linux-2.6.24-patch.gz
and I found that Palm Pre also uses the same switch controller but
they seems to have written another version of this driver.

---Trilok Soni
