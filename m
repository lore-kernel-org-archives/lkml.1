Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZFCLO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZFCLO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZFCLOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:14:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:24607 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZFCLOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:14:19 -0400
Message-ID: <4A265AF7.5000101@nokia.com>
Date: Wed, 03 Jun 2009 14:13:59 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain> <200905271323.29818.arnd@arndb.de> <4A1D31BA.6060903@nokia.com> <20090527123320.GF11363@kernel.dk> <4A1D3418.8060909@nokia.com> <20090527124719.GH11363@kernel.dk> <4A1E307B.1060807@nokia.com> <20090528081845.GU11363@kernel.dk>
In-Reply-To: <20090528081845.GU11363@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jun 2009 11:14:05.0010 (UTC) FILETIME=[67F5C320:01C9E43C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, May 28 2009, Artem Bityutskiy wrote:
>> Jens Axboe wrote:
>>> That would be great, I would have no problem integrating such a feature.
>>> It definitely makes sense.
>> Hi Al, Christoph,
>>
>> unless you have objections against the whole idea, I wonder if
>> it would be possible to make the patches which wrap sb->s_dirt
>> usage go via VFS tree first, and then I'd continue the timer
>> optimization work separately. IMO, wrapping s_dirt makes sense
>> in general. I mean, patches 01-17 from this series.
> 
> That makese sense, those are totally separate from the actual
> functionality.

Reminding ping.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
