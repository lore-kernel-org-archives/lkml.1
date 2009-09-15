Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZIOP7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZIOP7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZIOP67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZIOP66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:58:58 -0400
Message-ID: <4AAFB98F.80201@redhat.com>
Date: Tue, 15 Sep 2009 11:58:07 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Ryo Tsuruta <ryov@valinux.co.jp>, dhaval@linux.vnet.ibm.com,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org,
       nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: Regarding dm-ioband tests
References: <20090909105122.GF8828@linux.vnet.ibm.com> <20090910.165849.104059407.ryov@valinux.co.jp> <20090911095347.GD4474@linux.vnet.ibm.com> <20090916.001237.226784704.ryov@valinux.co.jp> <20090915151952.GH4846@balbir.in.ibm.com>
In-Reply-To: <20090915151952.GH4846@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-16 00:12:37]:

>> Why it is so bad to have multiple ways to configure? I think that it
>> rather gains in flexibility of configurations.
>>
> 
> The main issue I see is user confusion and distro issues. If a distro
> compiles cgroups and dmsetup provides both methods, what method
> do we recommend to end users? Also should system management tool
> support two configuration mechanisms for the same functionality?

It gets worse.

If the distro sets up things via cgroups and the admin tries
to use dmsetup - how does the configuration propagate between
the two mechanisms?

The sysadmin would expect that any changes made via dmsetup
will become visible via the config tools (that use cgroups),
too.

This will quickly increase the code requirements to ridiculous
proportions - or leave sysadmins confused and annoyed.

Neither is a good option, IMHO.

-- 
All rights reversed.
