Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYG0Lsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYG0Lsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYG0LsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:48:24 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:45873 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYG0LsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:48:23 -0400
Message-ID: <488C6085.9000507@numericable.fr>
Date: Sun, 27 Jul 2008 13:48:21 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Al Viro <viro@zeniv.linux.org.uk>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.26-git15] Cannot open "/proc/sys/net/ipv4/route/flush"
References: <488C5545.5010309@numericable.fr> <Pine.LNX.4.64.0807271228060.12405@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807271228060.12405@blonde.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sun, 27 Jul 2008, Rufus&  Azrael wrote:
>    
>> After compiling the very latest git kernel this morning, I have this message
>> on boot (on Gentoo box) :
>>
>> Bringing up interface lo
>>      127.0.0.1/8 ...
>>      Adding routes
>>          127.0.0.0/8 via 127.0.0.1 ...
>> Cannot open "/proc/sys/net/ipv4/route/flush"
>>
>> Do I put
>> /proc/sys/net/ipv4/route/flush=1
>> or
>> net.ipv4.conf.all.accept_source_route = 1
>>
>> in my sysctl.conf file ?
>>      
>
> If I may answer a different question, I believe you need Al Viro's
> [PATCH] lost sysctl fix
> http://lkml.org/lkml/2008/7/27/7
> and
> [PATCH] missing bits of net-namespace / sysctl
> http://lkml.org/lkml/2008/7/27/61
>
> Hugh
>
>    
Thanks Hugh,

I have applied these two patches and all is returning in order about sysctl.
