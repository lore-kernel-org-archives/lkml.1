Return-Path: <linux-kernel-owner+w=401wt.eu-S1945934AbXDLIO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945934AbXDLIO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945945AbXDLIO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:14:58 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52893 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945934AbXDLIO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:14:56 -0400
Date: Thu, 12 Apr 2007 10:14:03 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Egmont Koblinger <egmont@uhulinux.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070411193559.GA5881@ucw.cz>
Message-ID: <Pine.LNX.4.61.0704121013380.20436@yvahk01.tjqt.qr>
References: <20070406191245.GA11974@uhulinux.hu> <20070411193559.GA5881@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 19:36, Pavel Machek wrote:
>
>> +  while (max >= min) {
>> +    mid = (min + max) / 2;
>> +    if (ucs > table[mid].last)
>> +      min = mid + 1;
>> +    else if (ucs < table[mid].first)
>> +      max = mid - 1;
>> +    else
>> +      return 1;
>> +  }
>> +
>> +  return 0;
>> +}
>
>(Don't we already have rbtrees handling this just fine?)

Static initialization of an rbtre would become a beauty.


Jan
-- 
