Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbXFDTjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbXFDTjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbXFDTjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:39:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbXFDTjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:39:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=J5wo76pWvWKp6nvJ6TmpPzSHffYcoyov+tQirdUoHChyTgwGAG5yW14oEXAnA9xoJ
	ZD1Cx585miRjAcPnh3Jsw==
Message-ID: <46646A33.6090107@google.com>
Date: Mon, 04 Jun 2007 12:38:27 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 31 May 2007, Ethan Solomita wrote:
> 
>> The dirty map is only cleared (or freed) when the inode is cleared.
>> At that point no pages are attached to the inode anymore and therefore it can
>> be done without any locking. The dirty map therefore records all nodes that
>> have been used for dirty pages by that inode until the inode is no longer
>> used.
>>
>> Originally by Christoph Lameter <clameter@sgi.com>
> 
> You should preserve my Signed-off-by: since I wrote most of this. Is there 
> a changelog?
> 

	I wasn't sure of the etiquette -- I'd thought that by saying you had
signed it off that meant you were accepting my modifications, and didn't
want to presume. But I will change it if you like. No slight intended.

	Unfortunately I don't have a changelog, and since I've since forward
ported the changes it would be hard to produce. If you want to review it
you should probably review it all, because the forward porting may have
introduced issues.
	-- Ethan
