Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZJGQnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZJGQnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbZJGQny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbZJGQnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:43:53 -0400
Message-ID: <4ACCC4B7.4050805@redhat.com>
Date: Wed, 07 Oct 2009 12:41:27 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: vgoyal@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
References: <e98e18940910051111r110dc776l5105bf931761b842@mail.gmail.com>	<20091006.161744.189719641.ryov@valinux.co.jp>	<20091006112201.GA27866@redhat.com> <20091007.233805.183040347.ryov@valinux.co.jp>
In-Reply-To: <20091007.233805.183040347.ryov@valinux.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta wrote:

> If once dm-ioband is integrated into the LVM tools and bandwidth can
> be assigned per device by lvcreate, the use of dm-tools is no longer
> required for users.

A lot of large data center users have a SAN, with volume management
handled SAN-side and dedicated LUNs for different applications or
groups of applications.

Because of alignment issues, they typically use filesystems directly
on top of the LUNs, without partitions or LVM layers.  We cannot rely
on LVM for these systems, because people prefer not to use that.

Besides ... isn't the goal of the cgroups io bandwidth controller
to control the IO used by PROCESSES?

If we want to control processes, why would we want the configuration
to be applied to any other kind of object in the system?

-- 
All rights reversed.
