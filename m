Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXEUIiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXEUIiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760474AbXEUIiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:38:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:24003 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790AbXEUIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ArHN5zp/HE7AdzjEBCikP+x8EtdeSoRTkfjXg+AgVWwII1U7qZPgsrcHNE17UxOUv6EzIPDlmSf1IViEVGm3AB7i0dKh9bNFjPa49hZ4kOcSubF285CuPQscROrEDzfvLpf+cYBEU770SlRDho6SYHO3MCgNnU18KtGVAXaDYiw=
Message-ID: <46515A7D.20003@gmail.com>
Date: Mon, 21 May 2007 10:38:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Can't s2ram 22-rc2 [Was: 2.6.22-rc2 BUG: at slub_def.h:77]
References: <1179728579.11803.1.camel@localhost>	 <465153AF.5030008@gmail.com> <1179736498.4980.1.camel@localhost>
In-Reply-To: <1179736498.4980.1.camel@localhost>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Played with Cc list.

Soeren Sonnenburg napsal(a):
> On Mon, 2007-05-21 at 10:09 +0200, Jiri Slaby wrote:
>> Soeren Sonnenburg napsal(a):
>>> a regression (well I switched to slub) happens on boot...
> 
>>> BUG: at include/linux/slub_def.h:77 kmalloc_index()
>>>  [<c0176448>] get_slab+0x1c8/0x250
> [...]
>> Could you try this patch:
>> http://lkml.org/lkml/2007/5/19/171
> 
> yes, that does fix the issue (at least I don't see the BUG: anymore on
> boot). however I can no longer s2ram on 22rc2. 

Whit what kind of error or what happens?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
