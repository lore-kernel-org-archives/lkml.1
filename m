Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZEKGn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZEKGn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZEKGng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:43:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZEKGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Dk/DbJwA4CN4L64cnvcXGP7Gdx3aVWuwIH9PQKlX1AOWShlR9erM9M/+2ZbcDhUBZR
         5+pHDMatv12KXWx1JIEJgMwIX3BS5EpTMt6e3paK2BwWvLIugH5PfOFDhzkc+2ERLmbA
         NmdpPMWh48enf910qD/GR+Om+kfJ/jbLvgs+w=
Message-ID: <4A07C905.8010805@gmail.com>
Date: Mon, 11 May 2009 08:43:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops in wireless from today's git
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>	 <4A074682.6010403@gmail.com> <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
In-Reply-To: <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2009 12:29 AM, Chris Clayton wrote:
> 2009/5/10 Jiri Slaby <jirislaby@gmail.com>:
>> On 05/10/2009 09:39 PM, Chris Clayton wrote:
>>> I've just done a git pull and built, installed and booted the kernel.
>>> Unfortunately I got the oops below.
>> What's your HEAD? Looks like the issue solved by
>> 0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
>>
> 
> Sorry, I'm a real novice git user, but if by HEAD you mean the latest
> commit, its a4d7749be5de4a7261bcbe3c7d96c748792ec455. The file
> .git/FETCH_HEAD contains:
> 
> a4d7749be5de4a7261bcbe3c7d96c748792ec455                branch
> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

Ah, I though you're on wireless-testing git. Could you try to apply this
patch?
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=0cc113d866fa87c1455cbaff8d1f7ac054090bd5
