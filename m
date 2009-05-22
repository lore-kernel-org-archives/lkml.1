Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZEVSX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZEVSX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZEVSXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:23:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46274 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZEVSXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:23:52 -0400
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
From: Andi Kleen <andi@firstfloor.org>
References: <200905221139.26941.lkml@morethan.org>
Date: Fri, 22 May 2009 20:23:48 +0200
In-Reply-To: <200905221139.26941.lkml@morethan.org> (Michael S. Zick's message of "Fri, 22 May 2009 11:39:24 -0500")
Message-ID: <87hbzdngi3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Zick" <lkml@morethan.org> writes:

> Found in the bit-rot for 32-bit, x86, Uni-processor builds:

Actually uni processor should not use the lock prefix 
because it doesn't need it; the only exception are some special
ops used in para-virtualization which are special cased.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
