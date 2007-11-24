Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXKXSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXKXSEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbXKXSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:04:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:9722 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbXKXSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=axnGpiA0mpOpxOSjVdwulPc4FyFtPyclQhbadC+lx2RN/TVXyVuR2ur6AIdrkF5mNoiNLCAg8lVOZuF6AjDsRhR++B+9IwfKWOVyTXWjkoAiyeIGChXL1ag73UBhq1lUkat5YcCllHhDT5YB258ftktTlWy6iAPJSs4O3TrbMzE=
Message-ID: <474867B2.4080809@googlemail.com>
Date: Sat, 24 Nov 2007 19:04:34 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: kosaki <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
References: <20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com> <20071121004909.6157bb9a.akpm@linux-foundation.org> <20071124190604.276B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20071124190604.276B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kosaki wrote:
> Hi, Andrew 
> 
>>> Hi, Andrew
>>>
>>> I got following result in 'sync' command.
>>> It was too slow. (memory controller config is off ;)
>>> I attaches my .config.
>>> ==
>  (snip)
>> Well I wonder how we did that.
>>
>> It seems OK here from a quick test (i386, ext3-on-IDE).
>>
>> Maybe device driver/block breakage?

Try revert

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff_plain;h=8655a546c83fc43f0a73416bbd126d02de7ad6c0;hp=5bc717b6bdaaf52edf365eb7d9d8c89fec79df5d

See also :
http://lkml.org/lkml/2007/11/23/5

and search for '2.6.24-rc3-mm1: I/O error, system hangs' on LKML

> 
> I tested x86, ext3-on-SATA(/dev/sda).
> It seems works well.
> 
> Hmm...

IDE/SATA is fine here as well just SCSI broke


Regards,

Gabriel 
