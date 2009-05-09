Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZEILM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZEILM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 07:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZEILMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 07:12:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:3033 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZEILMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 07:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p0Vui8GJhbRCjOOt3m2S1RDL0MtBhv8fXUktP2yRlCYoM1ldZ81idYfD2lvs/G4dwH
         lh7RaW+ehUTC4RvAJA7E4eR607MqrBD31Xc50INZg5Ax15FDALv+9sNIykOL0+5k2D4m
         YAsa/+N+26JxpZ09AaXSMeZVYmt/DqClmMDRs=
MIME-Version: 1.0
In-Reply-To: <1241819971.19600.288.camel@nigel-laptop>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507215112.GC14611@elf.ucw.cz>
	 <1241746459.19600.246.camel@nigel-laptop>
	 <200905082144.57955.bzolnier@gmail.com>
	 <1241819971.19600.288.camel@nigel-laptop>
Date: Sat, 9 May 2009 14:12:46 +0300
X-Google-Sender-Auth: fdc79b1a5da27681
Message-ID: <84144f020905090412kf7622b2s9af8061b782c680e@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: nigel@tuxonice.net
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 21:44 +0200, Bartlomiej Zolnierkiewicz wrote:
>> Please proceed to Plan B then.
>>
>> Adding third core code framework to do the same thing is out of question
>> (probably same should have been said about adding second one in the past).

On Sat, May 9, 2009 at 12:59 AM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> Why? We have plenty of history of having multiple implementations of
> things (slub, slab and slob...).

Yes, so please don't make the same mistake we did. Once you have
multiple implementations in the kernel, it's extremely hard to get rid
of them.
