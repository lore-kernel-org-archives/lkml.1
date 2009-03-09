Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZCIRMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZCIRMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCIRMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:12:23 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:38912 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZCIRMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EhB5x0IFXFO+yeZC6/B/qf/tn1ZW1AdeulK7WWzr1hJOpVWUtYsVn7i51uDhdr6NV/
         BNtBszVBcfSt9RVoZ9ZDiUPdX5YkhwN7/gfq7ghHnTCAOhk989d7sTGryFt7Ef1BMAYr
         SuxZrhKroCODTKs/MhcP9ab0j+hpy4wksQHeo=
MIME-Version: 1.0
In-Reply-To: <20090308090102.2db82a5b@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
	 <1236192430.6785.111.camel@andreas-laptop>
	 <20090305161837.6ba80cc1@infradead.org>
	 <1236352543.6594.59.camel@andreas-laptop>
	 <20090306074548.36ed2f9f@infradead.org>
	 <1236509237.5645.151.camel@andreas-laptop>
	 <20090308090102.2db82a5b@infradead.org>
Date: Mon, 9 Mar 2009 17:12:18 +0000
Message-ID: <87a5b0800903091012j62da205bp8e825497f5ce59ec@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Will Newton <will.newton@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andreas Robinson <andr345@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 8, 2009 at 4:01 PM, Arjan van de Ven <arjan@infradead.org> wrote:

>> * Don't unpack initramfs twice. If CONFIG_BLK_DEV_RAM is
>>   set, the kernel decompresses the ramdisk just to see if
>>   it's a cpio archive or not, and then throws away the result.
>
> I actually have a patch for it stuck away somewhere; I thought it was
> sent upstream but apparently it was not. I'll dig it out and dust it
> off.

Please do. It's a big win in relative terms compared to the rest of
the boot for small systems.
