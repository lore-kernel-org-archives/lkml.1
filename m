Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZLFMWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZLFMWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZLFMWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:22:35 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:34224 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbZLFMWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:22:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: Fix timechart header handling
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
	<20091206115458.GA21964@elte.hu> <874oo48fq8.fsf@devron.myhome.or.jp>
	<20091206121353.GA31559@elte.hu>
Date: Sun, 06 Dec 2009 21:22:37 +0900
In-Reply-To: <20091206121353.GA31559@elte.hu> (Ingo Molnar's message of "Sun,
	6 Dec 2009 13:13:53 +0100")
Message-ID: <87zl5w70mq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> Yes. Rather, it doesn't work without this. (Without patch, it provide
>> svg output, but it doesn't provide correct sched state. And this issue
>> is only 64bit arch.)

[...]

> ok - thanks for the confirmation!

BTW, more correct fix would be using raw_filed_value() or something, so
it would become more robust. But, sorry, I didn't.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
