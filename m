Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZIOMmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZIOMmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZIOMmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:42:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33900 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZIOMmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wzZq0ANGG72hIfv0mxTpPc9f29R57pVA/M4pVQdlhE5Qv9qpwy/dgCD0RLek0HmtUf
         PNGN44KiEyRWuHVLPnLeA/ls493HfdYpwap65NRU7kzlxulTILk3uE2xQXAnH/Fpd5c/
         epxBjbPMHvj+20tw1EY3Q5RLgMiuUeh6+klqg=
MIME-Version: 1.0
In-Reply-To: <200909150745.16265.edt@aei.ca>
References: <200909100215.36350.ngupta@vflare.org>
	 <d760cf2d0909142339i30d74a9dic7ece86e7227c2e2@mail.gmail.com>
	 <84144f020909150030h1f9d8062sc39057b55a7ba6c0@mail.gmail.com>
	 <200909150745.16265.edt@aei.ca>
Date: Tue, 15 Sep 2009 15:42:09 +0300
X-Google-Sender-Auth: 72e5cd12af7f478f
Message-ID: <84144f020909150542k1d62f100ubaef3bb3b1cea592@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtual block device driver (ramzswap)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ed Tomlinson <edt@aei.ca>
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009 03:30:23 you wrote:
>> > So, its extremely difficult to wait for the proper fix.
>>
>> Then make ramzswap depend on !CONFIG_ARM. In any case, CONFIG_ARM bits
>> really don't belong into drivers/block.

On Tue, Sep 15, 2009 at 2:45 PM, Ed Tomlinson <edt@aei.ca> wrote:
> Problem is that ramzswap is usefull on boxes like the n800/n810...  So this is a bad
> suggestion from my POV.    How about a comment saying this code goes when the
> fix arrives???

Just put the driver in driver/staging until the issue is resolved.
