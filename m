Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbXFSJ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbXFSJ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXFSJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:28:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:3110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXFSJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=C+3GbOCWAxr2jO2y/yKJS9SHx7k/gGo9djE03Xw/ZM6Up5NP2lgzsIxxfIjqZd8udSXNs8uTGaDw1iY89map4rNz2PgeAUgpOMWgKVMR3sbqzBdcmIN0cF40rd5hIpmimjRSrTA6ekrpDmHEeIU4G7xkABnV8er7mf2YtC/W66w=
Message-ID: <4677A1C0.7020103@gmail.com>
Date: Tue, 19 Jun 2007 11:28:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Fengwei Yin <yfw.kernel@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       James Simmons <jsimmons@transvirtual.com>
Subject: Re: Type error in drivers/input/tsdev.c?
References: <ab18d8520706190211v1a5b4a17u57d0927400e15a5e@mail.gmail.com>
In-Reply-To: <ab18d8520706190211v1a5b4a17u57d0927400e15a5e@mail.gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengwei Yin napsal(a):
> Hi,
> In function tsdev_event() of drivers/input/tsdev.c,
> conversion from usec to milisec is like:
>    client->event[client->head].millisecs =
>         time.tv_usec / 100;
>                  ~~~~~~ should be 1000?

Seems so. James CCed.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
