Return-Path: <linux-kernel-owner+w=401wt.eu-S1763856AbZDBHiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763856AbZDBHiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZDBHh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:37:57 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:32854 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbZDBHh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:37:56 -0400
Message-ID: <49D46A8E.2090002@panasas.com>
Date: Thu, 02 Apr 2009 10:34:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com> <49D41729.4030407@kernel.org>
In-Reply-To: <49D41729.4030407@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 07:36:39.0270 (UTC) FILETIME=[C27B5060:01C9B365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2009 04:38 AM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>> Please consider that this code-path is used by me, in exofs and
>> pNFS-objcets in a very very hot path, where memory pressure is a
>> common scenario.
> 
> One quick question.  Don't the above paths map kernel pages to a
> request?
> 

Well vfs-page-cache pages. Any ideas?

> Thanks.
> 

