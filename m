Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZIIMhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZIIMhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZIIMhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:37:34 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47119 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZIIMhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:37:33 -0400
Message-ID: <4AA7A134.100@gmail.com>
Date: Wed, 09 Sep 2009 15:36:04 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090909092901.GA24185@localhost> <20090909122805.GA30238@infradead.org> <20090909123223.GB23006@localhost>
In-Reply-To: <20090909123223.GB23006@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Sep 2009 12:36:20.0788 (UTC) FILETIME=[22653740:01CA314A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 03:32 PM, Wu Fengguang wrote:
> On Wed, Sep 09, 2009 at 08:28:06PM +0800, Christoph Hellwig wrote:
>> On Wed, Sep 09, 2009 at 05:29:01PM +0800, Wu Fengguang wrote:
>>> It seems that balance_dirty_pages() is not coupled with MAX_WRITEBACK_PAGES.
>>> Instead it uses the much smaller (ratelimit_pages + ratelimit_pages / 2).
>>
>> With Jen's writeback patches applied balance_dirty_pages does not start
>> writeback itself anymore but calls bdi_start_writeback to let the
>> flusher thread do it.
>>
>> it would be good if we do any writeback tuning ontop of these patches..
>
> Ah OK. I'm using latest linux-next and expected his patches to be there..

At least few days ago they were there.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
