Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbXFUQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbXFUQtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbXFUQtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:49:16 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:49673 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbXFUQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:49:15 -0400
Date: Thu, 21 Jun 2007 18:49:12 +0200
From: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Wuerstlein <arw@arw.name>, linux-kernel@vger.kernel.org,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: Re: [PATCH] sns: add syscall to check signed state of a process
	[4/4]
Message-ID: <20070621164912.GD9741@cip.informatik.uni-erlangen.de>
References: <11824417553291-git-send-email-arw@arw.name> <961aa3350706210934m11e7f0cq96f384056878cb43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350706210934m11e7f0cq96f384056878cb43@mail.gmail.com>
X-Echelon-Scan: plutonium bomb dirty irak allah satan bush victory c4
	cocaine saddam wtc holy war believe god cia nsa
X-Echelon-Result: Terrorist
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 070621 18:34, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2007/6/22, Alexander Wuerstlein <arw@arw.name>:
>
>> +asmlinkage int sys_sns_is_trusted(pid_t p)
>> +{
>> +       struct task_struct *t;
>> +       rcu_read_lock();
>> +       t = find_task_by_pid(p);
>> +       if (IS_ERR(t)) {
>
> Shouldn't it be:
> if (!t) {
>        ...
> ?
>
> find_task_by_pid() returns NULL on failure.

You seem to be right, the rest of the kernel just does 'if (!t)'. We just used
IS_ERR() as the 'check for evil pointers' function.




Ciao,

Alexander Wuerstlein.
