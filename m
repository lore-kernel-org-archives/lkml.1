Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbYEGF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbYEGF6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYEGF6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:58:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47226 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYEGF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:58:06 -0400
Message-ID: <482144DF.3010300@yandex.ru>
Date: Wed, 07 May 2008 08:57:51 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2 06/28] UBIFS: add journal replay
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-7-git-send-email-Artem.Bityutskiy@nokia.com> <20080506220315.GA6464@joi>
In-Reply-To: <20080506220315.GA6464@joi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2008 05:57:58.0665 (UTC) FILETIME=[4D352F90:01C8B007]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
>> +	highest_ino_key(c, &key, -1);
>> +	while (*p) {
>> +		parent = *p;
>> +		r = rb_entry(parent, struct replay_entry, rb);
>> +		cmp = keys_cmp(c, &key, &r->key);
> 
> return value of keys_cmp is never used in this function

Right, these are old left-overs. Thanks for noticing,
will be fixed.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
