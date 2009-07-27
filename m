Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZG0HIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZG0HIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZG0HIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:08:40 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38644 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbZG0HIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JwJRicWnQuU6ryA8DogOZPMyyCi6p1ksMcT9sn+8hWbQDZMCbj0VJ/h+UoYWNZ1fva
         dtMuu54o/uMp9FYsDlRxgx4anw3JdfZsdnfLhgj9N0YfKkX5m0yoTpQnLDJlxnZrl5z5
         YdLRIBbf9hPh3STruklLeIwYZZFlsCYmwJORQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	 <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net>
	 <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com>
Date: Mon, 27 Jul 2009 10:08:38 +0300
X-Google-Sender-Auth: 22b955bc767a3f9a
Message-ID: <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 3:24 AM, David Rientjes<rientjes@google.com> wrote:
> On Sun, 26 Jul 2009, Larry Finger wrote:
>
>> Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.29 and 2.6.30.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> > be listed and let me know (either way).
>> >
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>> > Subject             : Page allocation failures with b43 and p54usb
>> > Submitter   : Larry Finger <Larry.Finger@lwfinger.net>
>> > Date                : 2009-04-29 21:01 (89 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>> >               http://lkml.org/lkml/2009/6/7/136
>> > Handled-By  : Johannes Berg <johannes@sipsolutions.net>
>>
>> This bug was fixed by commit 781b2ba6eb5f22440afac9c79a89ebd6e3674a60
>> entitled "SLUB: Out-of-memory diagnostics" by Pekka Enberg
>> <penberg@cs.helsinki.fi> and dated Wed Jun 10 18:50:32 2009 +0300.
>>
>
> Hmm, I'm remembering differently.  I thought the root problem here has
> only been fixed in Pekka's slab-2.6.git tree with "slub: add option to
> disable higher order debugging slabs" and isn't currently in Linus' tree.

Yup, the fix is in slab.git and queued for 2.6.32. There was some
complaints from Christoph from the patch that need to be addressed
still.

                                        Pekka
