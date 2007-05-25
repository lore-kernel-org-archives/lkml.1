Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbXEYIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbXEYIke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXEYIkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:40:20 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37029 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbXEYIkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:40:18 -0400
Message-ID: <4656A0F0.4050909@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 10:40:16 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] old declaration ritchie style fix
References: <87y7jemb1u.fsf@wanadoo.fr> <46568F7F.1040100@gmail.com>
In-Reply-To: <46568F7F.1040100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Yoann Padioleau napsal(a):
>>  static int
>> -receivepkt (target, buffer)
>> -	int target;
>> -	unsigned char *buffer;
>> +receivepkt (int target, unsigned char *buffer)
> 
> When you are at it, you can also get rid of bsd return-type-on-its-own-line
> style

return-type-on-its-own-line is IMO OK if it occurs consistently in a
file.  It can improve readability particularly if long return types are
combined with long function names.

> + remove the space before parenthesis.

Indeed.
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
