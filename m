Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYARNbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYARNbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbYARNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:31:12 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:3331 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYARNbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=vcyFyQEJJmkiwc7oEr3imZj6Rza+yF4tVgcZ1wHLfeBlXlYm1HaNjm4KQji0uFvoGIR6AlXPdWS5u4QGhpknRhyfcyzLYBdS/mr2k91BMGv81KZms7gtEzd2C8DXLhbQUcUAKvwbeo7yCVc4psNsGRBAZeGGfXo6LPRvT1T5fjM=
Message-ID: <4790AA17.6080907@gmail.com>
Date: Fri, 18 Jan 2008 08:31:03 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: gregory.haskins@gmail.com
CC: linux@sundmangroup.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org
Subject: Re: SCHED_FIFO & system()
References: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com> <4790A6C0.7070002@gmail.com>
In-Reply-To: <4790A6C0.7070002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

> 
> (*) I have no information on whether the futex-plist implemetation was 
> pulled from the tree to cause your regression.  It is possible that the 
> changes between 22 and 23 are just tickling your environment enough to 
> bring out this RT-preempt issue.
> 


Hmm...seems I should not send out email before my morning coffee ;)

I think I was answering

http://lkml.org/lkml/2008/1/18/43

having read them back to back.  Sorry for the confusion.


There's a chance that this is what is causing your issue, Matias, but 
you should also confirm that what this module is doing doesn't disable 
preemption.  That would also cause the issue.

HTH
-Greg
