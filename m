Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZDENBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZDENBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 09:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZDENBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 09:01:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZDENBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 09:01:33 -0400
Message-ID: <49D8ABA8.20700@redhat.com>
Date: Sun, 05 Apr 2009 16:01:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Hallberg <hallberg68@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Intepreting an oops
References: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
In-Reply-To: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hallberg wrote:
> How does one translate the offset in the function to a line number in the source code?
> [  218.418473] Call Trace:
> [  218.418484]  [] :nnpfs:nnpfs_writepage+0xab/0x230
>   

You can use 'objdump -Sr nnpfs.ko' and look for the address of 
nnpfs_writepage, plus 0xab.

-- 
error compiling committee.c: too many arguments to function

