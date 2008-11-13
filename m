Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYKMTHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYKMTHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKMTHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:07:02 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:31485 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYKMTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fEFBiU9k13SKFXP8STws30juYo8PIGFc4/QapDWiWgBSzSoeYv/nyKFol87ze4R6HW
         BEXLEMtdjzkUFVj/pZMEWSaylnwSHKzz6J7RFs7jNllGwF3RZbYAoub72CM+FBbR2/nN
         T1qqJAYAKiOHyD3u3R9zkWbbm1dLvdfCFVyfo=
Message-ID: <b2cc26e40811131106g7a1c46d0y89d24b11cb0570fb@mail.gmail.com>
Date: Thu, 13 Nov 2008 20:06:58 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Olaf van der Spek" <olafvdspek@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
In-Reply-To: <20081113112409.GK13263@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <20081113112409.GK13263@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:24 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Thu, Nov 13, 2008 at 12:20:44AM +0100, Olaf van der Spek escreveu:
>> Hi,
>>
>> Quite often in discussions, I see people claiming Unix sockets are
>> faster then TCP sockets on a connection that stays inside localhost.
>> Let's say from app A to app B.
>> Is this indeed the case and if so, how much and why?
>> My assumption is that the kernel can optimize the 'connection' and let
>> any performance differences disappear.
>
> How much? Please measure.

I can't be the first one to wonder about this. Has nobody done this
kind of benchmark before?

> Faster? Not necessarily, Nagle comes to mind,

Eh, wouldn't that make TCP slower instead of faster?

> among others. What kind of traffic? That matters too.
>
> Start here: http://en.wikipedia.org/wiki/Nagle's_algorithm

Eh, I assume that algorithm is disabled on localhost.
