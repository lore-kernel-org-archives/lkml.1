Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbZHWQBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbZHWQBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933839AbZHWQBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:01:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:24116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbZHWQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=K5qiZI2W+ye1nVnE9o3KwaxoPEopyGe4AeCaAYYxRpbhX9vyhehumQPTq6p629p+uq
         ZG92mvju2saMO7PNVNwsFnskkTFf33N2HMhopvbTeQZ3HrBakkGIawTVU74Pgg3OVt8n
         b8Ws4oo9bz2usSxpzYB4D1rvCxpEXLbsKiBJk=
Date: Mon, 24 Aug 2009 00:04:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Matthias Urlichs <matthias@urlichs.de>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] scripts: add typdef removal tool
Message-ID: <20090823160422.GA12070@hack>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com> <20090817060203.GL5039@cr0.nay.redhat.com> <1251033773.10339.1105.camel@kiste>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1251033773.10339.1105.camel@kiste>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 03:22:53PM +0200, Matthias Urlichs wrote:
>On Mon, 2009-08-17 at 14:02 +0800, Amerigo Wang wrote:
>> These two 'find's can be merged:
>> 
>>   find $REM_PATH -type f -name '*.c' -o -name '*.h'
>> 
>You mean
>
>find $REM_PATH -type f \( -name '*.c' -o -name '*.h' \)
>
>or
>
>find $REM_PATH -type f -name '*.[ch]'
>
>Otherwise, directory names ending in .h will cause false postiives.
>(Yes, I know that we don't have any of those at the moment, but …)

Yeah, sure. The latter one above is better.

-- 
Live like a child, think like the god.
 
