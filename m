Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYJQIJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYJQIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYJQIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:09:31 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:36081 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbYJQIJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:09:28 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: no way to swapoff a deleted swap file?
To: David Newall <davidn@davidnewall.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <peterz@infradead.org>, Peter Cordes <peter@cordes.ca>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       linux-mm <linux-mm@kvack.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 17 Oct 2008 10:20:22 +0200
References: <bnlDw-5vQ-7@gated-at.bofh.it> <bnwpg-2EA-17@gated-at.bofh.it> <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall <davidn@davidnewall.com> wrote:
> Hugh Dickins wrote:
>> On Thu, 16 Oct 2008, Peter Zijlstra wrote:

>>> On Wed, 2008-10-15 at 17:21 -0300, Peter Cordes wrote:
>>>     
>>>> I unlinked a swapfile without realizing I was still swapping on it.

[...]

> Me too.  The kernel shouldn't protect the administrator against all
> possible mistakes; and this mistake is one of them.  Besides, who's to
> say it's always a mistake?  Somebody might want their swap file to have
> zero links.

Somebody might want their swapfiles to have zero links, _and_ the possibility
of doing swapoff. If you can do it by keeping some fds open to let
/proc/pid/fd point to the files, I think it's OK.

