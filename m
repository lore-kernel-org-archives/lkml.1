Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZI3U3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZI3U3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZI3U3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:29:20 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42607 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZI3U3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uSvQfJhP89ZLhHgPrEe9JW3qGlFGHlOlZ4y9TbgS24AKYQTIprWUuZ2oa6AvZqs5Gv
         LnfEWB6O9Qx8uIkPgdwlI19Lz2f3bpqILYk1HwFc8MspeA52CbJSIZ7GDkEAqJhG5NAQ
         wdK4IzjuFS1RnyuKz2sCzblpHuOVN1KGiYEy4=
Message-ID: <4AC3BF62.9020706@gmail.com>
Date: Wed, 30 Sep 2009 22:28:18 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: N_PPP_SYNC ldisc BUG: sleeping function called from invalid context
References: <4AC37032.4030901@imap.cc> <20090930174704.796b24b9@lxorguk.ukuu.org.uk> <4AC3A986.4080808@imap.cc>
In-Reply-To: <4AC3A986.4080808@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote, On 09/30/2009 08:55 PM:

> Alan Cox schrieb:
>>>  [<c026d39b>] tty_unthrottle+0x10/0x38
>>>  [<f8dcc31f>] ppp_sync_receive+0x168/0x170 [ppp_synctty]
>>>  [<f8fbb9ce>] handle_minor_recv+0x187/0x1cd [capi]
>>>  [<f8fbc19b>] capi_recv_message+0x1d9/0x24e [capi]
>> Really need to see the rest of the call trace to be sure
> 
> There wasn't more than what I posted. I had six of them, they looked all
> identical, and all of them ended after the kernel_thread_helper line. 
...
> Why then does mutex_lock() complain?


Maybe it doesn't matter here, but this: 

> INFO: lockdep is turned off.
suggests there was some lockdep issue/warning earlier.


Jarek P.
