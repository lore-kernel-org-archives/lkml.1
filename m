Return-Path: <linux-kernel-owner+w=401wt.eu-S932986AbXIFU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbXIFU65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXIFU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:58:49 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:33093 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbXIFU6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:58:47 -0400
Message-ID: <46E069F9.2040700@davidnewall.com>
Date: Fri, 07 Sep 2007 06:28:33 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Guilherme Vilela <vilela.list@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem to recognize that the file system is full
References: <89a10cbc0709040951u1786e7e3g76708bfcb7117f44@mail.gmail.com> <89a10cbc0709040953i58f64a9cx957d69dd35519083@mail.gmail.com> <Pine.LNX.4.64.0709061445290.25942@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709061445290.25942@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Sep 4 2007 13:53, Guilherme Vilela wrote:
>   
>> I'm tryng to mount a nfs file system with the option async and run a
>> program that writes to the file system. The problem is that the
>> program keep writing even when the file system is full.
>>     
>
> man 5 exports
>
>    async  This option allows the NFS server to violate  the  NFS  protocol
>           and  reply  to  requests before any changes made by that request
>           have been committed to stable storage (e.g. disc drive).
>   

(That means it's a feature.)

>> This program does'nt occur when mounting with the sync
>> option or with async and noac option, but the performance get very
>> poor and that is important to my application. The problem doesnt occur
>> too with the local file system. I'm running linux centos 5.0.
>>     
>
> About ac/localhost, I am not really sure what makes it work.
man 5 nfs

   noac Disable attribute caching, and force synchronous writes.  This
        extracts a server performance penalty but it allows two different
        NFS clients to get reasonable good results when both clients are
        actively writing to common filesystem on the server.

