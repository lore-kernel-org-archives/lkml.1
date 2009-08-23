Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbZHWR7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbZHWR7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 13:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbZHWR7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 13:59:39 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39175 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbZHWR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 13:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VWrUzmoGYnwBiZ8LYbT8cwykEgjm2R5lYa0Zc6vcVG/xeqNSvv23cofrsWereHgmMf
         si+lzW9nw09ZMmUafawtY23kGZMMB5z3C0fe3H8cAW7TDxhZWacS2jlGSOWLPUq9a7Ox
         SRRyXjFqSkindMRdIcZ7PsRfF2fTNBHlXxdEM=
Message-ID: <4A918389.8050301@gmail.com>
Date: Sun, 23 Aug 2009 19:59:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matthias Urlichs <matthias@urlichs.de>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] scripts: add typdef removal tool
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>	<20090817060203.GL5039@cr0.nay.redhat.com> <1251033773.10339.1105.camel@kiste>
In-Reply-To: <1251033773.10339.1105.camel@kiste>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2009 03:22 PM, Matthias Urlichs wrote:
> Otherwise, directory names ending in .h will cause false postiives.
> (Yes, I know that we don't have any of those at the moment, but …)

-type f excludes directories. But people (me including) sometimes do
have .c files in the root kernel source directory.
