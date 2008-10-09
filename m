Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYJIHSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYJIHSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYJIHRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:17:55 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:64595 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYJIHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:17:54 -0400
Message-ID: <48EDB01E.4030501@nttdata.co.jp>
Date: Thu, 09 Oct 2008 16:17:50 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #10 (linux-next) 4/8] Memory and pathname management
 functions.
References: <20081009042814.398846861@nttdata.co.jp>	<20081009042917.949002170@nttdata.co.jp> <20081009151840.ac066cc6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081009151840.ac066cc6.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 07:17:50.0940 (UTC) FILETIME=[23A791C0:01C929DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
>> +
>> +#define MAX_HASH 256
>> +
> Maybe based on typical workload and usage but
> It's better to write why hash size is fixed size of "256", when you
> use hash. 
TOMOYO uses this hash only when appending a string into the string 
table. Frequency of appending strings is very low. So we don't need 
large (e.g. 64k) hash size. 256 will be sufficient.

I'll append above as a comment.

Regards,

