Return-Path: <linux-kernel-owner+w=401wt.eu-S1765775AbYBODRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765775AbYBODRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYBODQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:16:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:39958 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYBODQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:16:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Cm7MvIzi8vpZMBRDWC14AIOtTi2KDzejDSfQSJVqgcNTo/FfeWHP1lCjf7ctEQojCXpzXDH3qVgN2rHacFxF7kZUMKVFeNbhmvwi90tJvQ6YNIh3Ja9+ccDUPJW7V8POE/4EPHnN43TgIWpjxHZnBlo7Xk+YeMg9u9wmag2WZPo=
Message-ID: <47B50420.3060403@gmail.com>
Date: Fri, 15 Feb 2008 12:16:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com>	<20080213155701.48871761.akpm@linux-foundation.org>	<47B38E13.1060503@gmail.com>	<20080213170950.86945835.akpm@linux-foundation.org>	<47B398B3.40308@gmail.com>	<47B4EFAB.2040102@gmail.com>	<20080214182700.a9a706e9.akpm@linux-foundation.org>	<47B4FA9C.9080809@gmail.com> <20080214185003.9ca9a640.akpm@linux-foundation.org>
In-Reply-To: <20080214185003.9ca9a640.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> So, I guess it's NACK w/o suggested alternatives, right?
> 
> I wouldn't nack without good reasons, and I have none here.  I don't have
> very strong opinions either way.

I was just wondering whether I should just go with snprintf dancing in
eh_link_report, which does make sense if not many need merging printk.

> As a seat-of-the-pants thing, it does seem to be a lot of core code to
> solve a fairly minor problem in (afaik) one remote place.  But I haven't
> looked - perhaps there are other places which could be improved if such
> facilities were available.

Okay, I see.  I'll look around and see whether there are other places
which can use it.  I can think of a few in SCSI.  Let's see.

Thanks.

-- 
tejun
