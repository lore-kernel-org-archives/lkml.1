Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZCLUq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZCLUq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZCLUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:46:46 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54552 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZCLUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:46:46 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: phillips@phunq.net, tux3@tux3.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
References: <200903110925.37614.phillips@phunq.net>
	<20090311114211.89eed5b8.akpm@linux-foundation.org>
	<87vdqeogtm.fsf@devron.myhome.or.jp>
	<20090312130222.b149cf36.akpm@linux-foundation.org>
Date: Fri, 13 Mar 2009 05:46:39 +0900
In-Reply-To: <20090312130222.b149cf36.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 12 Mar 2009 13:02:22 -0700")
Message-ID: <87k56ulb9s.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 13 Mar 2009 01:18:29 +0900
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > - When 'bh' is known to be non-NULL, use put_bh() rather than brelse().
>> 
>> It sounds strange. Almost all bh is non-NULL. This means we are going to
>> replace almost all brelse() by put_bh()?
>> 
>
> Well..  you can make up your own mind about this.  If you see benefit
> in the NULL-checking and extra debugging which brelse() provides then
> continue to use brelse().

I thought someone started to convert it. Ok, personally, I think
NULL-check is just not needed always, and if it is needed, check it
explicitly.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
