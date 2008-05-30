Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYE3CQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYE3CQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbYE3CQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:16:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYE3CQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:16:44 -0400
Message-ID: <483F6367.1040701@cn.fujitsu.com>
Date: Fri, 30 May 2008 10:16:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function update_cpumask()
 and update_nodemask()
References: <483E564A.5050807@cn.fujitsu.com>	<20080529031656.cdc38001.pj@sgi.com>	<483F5DAA.5060004@cn.fujitsu.com> <20080529205344.4ba1efdb.pj@sgi.com>
In-Reply-To: <20080529205344.4ba1efdb.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-5-30 9:53 Paul Jackson wrote:
> Miao wrote:
>> I think that it is unnecessary to change cpuset_cpus_allowed_locked()'s comment
>> because it isn't a static function, it is a extern function
> 
> Yes, you are correct.  My mistake.  Sorry.
> 

I check kernel/cpuset.c and find many static functions with "/**" comment.
So I want to remove the special commenting convention for them.

