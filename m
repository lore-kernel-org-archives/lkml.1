Return-Path: <linux-kernel-owner+w=401wt.eu-S1161114AbXAZSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbXAZSE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161117AbXAZSE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:04:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:42499 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161114AbXAZSE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ogvSEX2VbPGc6KHQ4QFOghRmQS9A9bWh1M5yfCEv4SFfUmlpZ1sfIdHRZKBFa+tb6HommffMLdMl8C68dQByl7S6qq2OuSmI7rHiPYKVPX/KsSQQcg1d+0Cy2i5PO58qMotgOSy6NhdOMm+AzoZn5QP/q/fzliJWfYIBCFQCdAs=
Message-ID: <45BA42B9.7020203@googlemail.com>
Date: Fri, 26 Jan 2007 19:04:41 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

akpm@osdl.org napisa³(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

use-zvc-for-free_pages.patch
breaks swsusp

kernel/power/swsusp.c: In function 'swsusp_shrink_memory':
kernel/power/swsusp.c:233: error: 'struct zone' has no member named 'free_pages'
kernel/power/swsusp.c:235: error: 'struct zone' has no member named 'free_pages'
make[2]: *** [kernel/power/swsusp.o] Error 1
make[1]: *** [kernel/power] Error 2
make: *** [kernel] Error 2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
