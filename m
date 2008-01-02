Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYACAhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYACAhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYACAhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:37:37 -0500
Received: from smtp102.plus.mail.mud.yahoo.com ([68.142.206.235]:42687 "HELO
	smtp102.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753905AbYACAhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:37:36 -0500
X-Greylist: delayed 4606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 19:37:36 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GJNHW9qwisRYJY7EZbv46w23zWigqqFi1iBMD9JVXrIgDOUZnRVQ1OSlo2taD8OBlr96Cuv0Evg5rrWPbDoNI3Wj+Kp0lXp4mql5raye+enP1u8ABedeNYXS6DIhtzwC2z8Dx+kKulmfS88P+OVJMZlnmBCv40meM19lgroYNsk=  ;
X-YMail-OSG: dXXcb8kVM1kBeuUf84sDb7JcviML4YgHCK5AHPhNxSJGKYoZ
Message-ID: <477C10AD.7060303@yahoo.fr>
Date: Wed, 02 Jan 2008 23:31:09 +0100
From: =?ISO-8859-1?Q?R=E9mi_H=E9rilier?= <rherilier@yahoo.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071212)
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: linux-kernel@vger.kernel.org, dtor@mail.ru, linux-input@vger.kernel.org
Subject: Re: PATCH] adding wistron_btns support for X86_64 systems.
References: <200712222040.14422.carlos@strangeworlds.co.uk>
In-Reply-To: <200712222040.14422.carlos@strangeworlds.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho wrote:
> (CC'ing linux-input, as that is the relevant subsystem list for wistron-btns).
> 
> Rémi Hérilier wrote:
>> To use my previous patch (wistron_btns support for fujitsu-siemens amilo
>> pro edition v3505) with my laptop, I need to make the wistron module
>> compile for x86_64. It is based on Linux 2.4.24-rc4 too.
> 
> NAK.
> 
> You cannot make 32 bit BIOS calls in a 64 bit OS.
> 
> This will (and does) segfault on x86-64 (tested on my Aspire 5020, where  
> call_bios wistron-btns just segfaults on x86-64 with this patch).
> 
> This is a known issue, and the reason why wistron-btns (and the out-of-tree 
> acerhk) have not been ported to x86-64.
> 
> -Carlos

Yes, in theory, this must segfault on x86-64.

In pratice, there is one laptop where it seems to works (no problem
for 3 weeks). A good reason to find why.


Best regards

Remi Herilier
