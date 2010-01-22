Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518Ab0AVQFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0AVQFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797Ab0AVQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:05:07 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46399 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0AVQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:05:05 -0500
Message-ID: <4B59CB32.5080901@nortel.com>
Date: Fri, 22 Jan 2010 09:58:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Luca Zini <luca.zini@gmail.com>
CC: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       aagaande@gmail.com, rdelcueto@hotmail.com, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
References: <201001211258.23499.luca.zini@gmail.com> <1264152314.12530.8.camel@marge.simson.net> <1264152860.4283.1442.camel@laptop> <201001221222.28516.luca.zini@gmail.com>
In-Reply-To: <201001221222.28516.luca.zini@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2010 16:04:20.0813 (UTC) FILETIME=[8ED627D0:01CA9B7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/22/2010 05:22 AM, Luca Zini wrote:

> with nice set to 19 a processor 3 reach the maximum speed,  with nice
set to
> -20 its maximum value is 300-400 mhz under the maximum value.

I wonder if at lower nice levels the timing on something changes,
forcing multiple cores to be active just often enough to keep the i7
from doing the turbo boost thing, whereas with higher nice levels
everything is serialized allowing the boost to be enabled.

Chris
