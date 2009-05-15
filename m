Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZEOGwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZEOGwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZEOGwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:52:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47027 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZEOGwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:52:33 -0400
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sys_write() should write all valid data
From: Andi Kleen <andi@firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
Date: Fri, 15 May 2009 08:52:29 +0200
In-Reply-To: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> (Vitaly Mayatskikh's message of "Thu, 14 May 2009 18:18:59 +0200")
Message-ID: <87octuq2mq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

> There's user-visible misbehavour in sys_write(): when user tries to
> put down to disk some data, which crosses boundary of existing
> memory, sys_write() either immediately returns with EFAULT or writes
> first page(s).

What's wrong with that? Seems like perfectly fine behaviour to me.
Did it break some program of yours? If yes can you describe the
scenario?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
