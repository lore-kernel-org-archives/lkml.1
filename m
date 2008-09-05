Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYIEH64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYIEH64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYIEH6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:58:44 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:19441 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbYIEH6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nwUiPGQNNe3jOWhcIUSbddivDuVaMZftXfJGa0cDAj4Kv+KqKftBZD86svGKgYJsPu
         4V1D/qft/oiD1A9IoSDzLKmCogMQ3VPX9ZBkQf3j3h2KSghUNSYUsaaWsrM11EFXRUjL
         fEG/xxT2WlLOJnRf8/78e4/G6lXqFS/To7b/k=
Message-ID: <19f34abd0809050058h1e463acdnbfdbfcfa3ef79391@mail.gmail.com>
Date: Fri, 5 Sep 2008 09:58:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: PROBLEM: Kernel 2.6.26 oops if I unplug my Logitech USB 1.1 headset
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Edgar Kalkowski" <eMail@edgar-kalkowski.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <s5hod33t6f9.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C069B1.3000201@edgar-kalkowski.de>
	 <20080904172822.e5390a59.akpm@linux-foundation.org>
	 <s5hod33t6f9.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 9:09 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 4 Sep 2008 17:28:22 -0700,
> Andrew Morton wrote:
>>
>> On Fri, 05 Sep 2008 01:05:21 +0200
>> Edgar Kalkowski <eMail@edgar-kalkowski.de> wrote:
>>
>> > Dear kernel hackers. ;)
>> >
>> > [1.] One line summary of the problem: If I unplug my USB-Headset the kernel oopses.
>>
>> cc's added.
>>
>> Might be USB, might be ALSA.
>
> Hm, it's hard to guess...
> Edgar, could you check whether it happens with 2.6.25?

Hi,

I recognize this address:

>>> BUG: unable to handle kernel paging request at 00100100

Is this a magic value? I also got it, see for example:
http://lkml.org/lkml/2008/8/21/426

Google will also recognize it:
http://www.google.com/search?hl=en&q="unable+to+handle+kernel+paging+request"+00100100

Where does it come from?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
