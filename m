Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZJ0KXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZJ0KXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZJ0KXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:23:08 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37242 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZJ0KXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=czLj34DKAtnscW8iq8BenhIcVOZpjfJ63TacJhUefBJI14+6511w8XiJnZmSDdTkwh
         W7vjSFXE278TMr3zIOnMMnlkx0XpxFDdo+JEftjOrwQn5EpGZHOg/oaZOMI07dc6NuFH
         tLtTWvmR1c+ZyFiyDok9kFyj1tefzSilsw7XA=
MIME-Version: 1.0
In-Reply-To: <4AE6C998.9040405@lumino.de>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com>
	 <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com>
	 <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com>
	 <4AE5F1D2.9030908@s5r6.in-berlin.de>
	 <f22d86810910261205r232db5d4re97a54827c7adab3@mail.gmail.com>
	 <4AE6C998.9040405@lumino.de>
Date: Tue, 27 Oct 2009 03:23:12 -0700
Message-ID: <f22d86810910270323m6e004576ya4da96afc02e3d07@mail.gmail.com>
Subject: Re: Difference between atomic operations and memory barriers
From: "Leonidas ." <leonidas137@gmail.com>
To: Michael Schnell <mschnell@lumino.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 3:21 AM, Michael Schnell <mschnell@lumino.de> wrote:
> Leonidas . wrote:
>>
>> any_t *ptr = something;
>>
>> is always atomic even on SMPs without using locks, barriers then my
>> doubt is cleared. Thanks.
>
> I assume that this only holds if the pointer (not the thing it points
> to) is denoted as volatile.
>
> -Michael
>

I dont think so,  volatile would only ensure no caching, so some cpus
might see the cached
pointer (this is where you would want to use barriers), but pointer
assignment would still be atomic.


-Leo.
