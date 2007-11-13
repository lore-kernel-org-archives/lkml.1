Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbXKMNgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbXKMNgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXKMNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:36:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41460 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbXKMNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KOUx45BWkW78BEgoWRPa6umV1WsKceiqqYFa5FonJA6EcL7HljARYi0ZChC5E2aQMLE8qDD9IfjRIXK04RiIDcAE21e0m+nDY9Fgu7da7I4nArMnxQhMLcR6LNBNWA0+8zg8N9kcwNxKpA7yanaU1GiVkrZGimzHHHFUzsbY85g=
Message-ID: <4739A840.4000902@gmail.com>
Date: Tue, 13 Nov 2007 14:36:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cscope build warning [Was: mm snapshot broken-out-2007-11-13-04-14.tar.gz
 uploaded]
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org> <47399B4D.5040208@gmail.com> <20071113132712.GA31270@uranus.ravnborg.org>
In-Reply-To: <20071113132712.GA31270@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2007 02:27 PM, Sam Ravnborg wrote:
> On Tue, Nov 13, 2007 at 01:40:45PM +0100, Jiri Slaby wrote:
>> On 11/13/2007 01:15 PM, akpm@linux-foundation.org wrote:
>>> The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
>> $ uname -a
>> Linux bellona 2.6.23-rc8-mm2_64 #58 SMP Fri Sep 28 08:52:12 CEST 2007 x86_64
>> x86_64 x86_64 GNU/Linux
>> $ make O=../bu cscope
>>   FILELST cscope.files
>> find: /home/l/latest/xxx/arch/x86_64: není souborem ani adresářem
>>   MAKE    cscope.out
>>
> 
> I have following fix queued in my inbox:
> 
> This patch fixed the following errors when doing "make cscope" and
> "make cscope ARCH=um".
> 
>   FILELST cscope.files
> find: arch/i386: No such file or directory
>   MAKE    cscope.out

Ok, thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
