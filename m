Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYHRVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYHRVtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYHRVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:49:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:51331 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYHRVti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mIhwU3ZTP4z50lik9Uez30VUzm97cL+qDnkK6tVgkoSJrT/SN7l2lUpUJpiDiYCfy1
         +VZQrYONG5B+tp4CuJVaQB0NZhFI+YtQxiLWxIMcqccNuwGaeD+0L/tNPHQk1hO1Qnip
         LRcQpoJL6ALlNonJhgtfVHIy7xB9GcD0aMbjg=
Message-ID: <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
Date: Tue, 19 Aug 2008 00:49:35 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: BUG in free_block (tainted)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <48A9ECD2.8030801@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A9E97B.6060601@simon.arlott.org.uk>
	 <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
	 <48A9ECD2.8030801@simon.arlott.org.uk>
X-Google-Sender-Auth: 2f6289bf8c344321
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Tue, Aug 19, 2008 at 12:28 AM, Simon Arlott <simon@fire.lp0.eu> wrote:
>>> http://img169.imageshack.us/img169/1170/1005548cp9.jpg
>>>
>>> 2.6.27-rc3 09873-gb08c7f5
>>>
>>> (Tainted with fglrx, but X hadn't been run...)

On 18/08/08 22:37, Pekka Enberg wrote:
>> Looks like SLAB corruption so fglrx could have caused this even if you
>> just loaded the module. Do you have CONFIG_DEBUG_SLAB enabled? If not,
>> you might want to try to reproduce this with it. Of course,
>> reproducing the oops without fglrx would be most helpful. :-)

On Tue, Aug 19, 2008 at 12:42 AM, Simon Arlott <simon@fire.lp0.eu> wrote:
> In that case please disregard this completely. It's not yet happened again.
>
> fglrx completely breaks slab in fantastic ways... I could show you my
> /proc/slabinfo... the start of it is badly corrupted - but only if X has
> been started (attached).
>
> I might try enabling CONFIG_DEBUG_SLAB, perhaps it can detect that bug...

Aww, apparently the fglrx driver creates tons of SLAB caches with
really funky names for no good reason... Oh well, one more reason to
stay away from that crap and help out the nouveau folks instead ;-).

                         Pekka
