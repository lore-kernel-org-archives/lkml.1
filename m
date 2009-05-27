Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZE0Bm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZE0Bm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZE0BmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:42:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49397 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZE0BmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:42:18 -0400
Message-ID: <4A1C9AC4.3090704@cn.fujitsu.com>
Date: Wed, 27 May 2009 09:43:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <20090526060232.GA10669@infradead.org>
In-Reply-To: <20090526060232.GA10669@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 12:04:28PM +0800, Li Zefan wrote:
>> This changes __string(..., src) to __string(..., len), thus makes it more
>> general, and then block TRACE_EVENT() can use it.
>>
>> Also introduce __fetch_str(), which is used in TP_assign() and returns
>> the address of the string, while __get_str() is used in TP_print().
> 
> If you want to make it really generaly dealing with NULL string pointers
> would be extremly helpful.  I ran into that limitation (and the length
> one fixed here) when converting the XFS tracing over.
> 

I'm not suffering from NULL str, so I'm not quite sure how you want __string()
deal with it.


