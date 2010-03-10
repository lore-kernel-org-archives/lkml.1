Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0CJABq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:01:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56919 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0CJABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oyURs6U3RO2lr+sP7n1ew9TLfFcHGAR8ouRokNX5omA81fPLZk74stKqCheTcYjN6K
         ZCQ+H6rFT3C/aHMLjAAPz2Fn3VgBlIgcFxpbk+BXXN5hZWrJbhnfHHuwGEnzU2kD2qwY
         ngudHz+qJPYWhaBMHvlir5mhElBCd+TKtki+w=
MIME-Version: 1.0
In-Reply-To: <1268179164.3339.2.camel@localhost.localdomain>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-4-git-send-email-johnstul@us.ibm.com> <1267675049-12337-5-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-6-git-send-email-johnstul@us.ibm.com> <1267675049-12337-7-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-8-git-send-email-johnstul@us.ibm.com> <1267675049-12337-9-git-send-email-johnstul@us.ibm.com> 
	<1267675049-12337-10-git-send-email-johnstul@us.ibm.com> <8bd0f97a1003091553j1f88ef69m748bf1ef54371c2f@mail.gmail.com> 
	<1268179164.3339.2.camel@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 9 Mar 2010 19:01:23 -0500
Message-ID: <8bd0f97a1003091601wd364bb3nd2b5e24fee0722d@mail.gmail.com>
Subject: Re: [PATCH 09/14] blackfin: Convert blackfin to use 
	read/update_persistent_clock
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 18:59, john stultz wrote:
> On Tue, 2010-03-09 at 18:53 -0500, Mike Frysinger wrote:
>> On Wed, Mar 3, 2010 at 22:57, John Stultz wrote:
>> > This patch converts the blackfin architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.
>> >
>> > I have not built or tested this patch, so help from arch maintainers would be appreciated.
>>
>> Blackfin builds & boots with generic clockevents and w/out
>> Acked-by: Mike Frysinger <vapier@gentoo.org>
>
> Cool!
>
>> did you want me to merge it for 2.6.35 or should it go through with
>> your patchset ?
>
> I'd say go ahead and merge it.

will do
-mike
