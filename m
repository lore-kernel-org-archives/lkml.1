Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZIVQpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZIVQpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZIVQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:45:15 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:58325 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIVQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:45:14 -0400
Message-ID: <4AB8FF4D.6070607@oss.ntt.co.jp>
Date: Wed, 23 Sep 2009 01:46:05 +0900
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Do not allow umounting of frozen filesystems
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp> <4A9692CF.80508@oss.ntt.co.jp> <20090922110737.GL5858@ZenIV.linux.org.uk> <4AB8F3EC.6050607@redhat.com>
In-Reply-To: <4AB8F3EC.6050607@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen さんは書きました:
> Al Viro wrote:
> ...
>
>   
>> IOW, I'd rather add two new ioctls (check if frozen/thaw), both by
>> bdev.  On top of the first two patches in this set.
>>     
>
>   
>> Comments?
>>     
>
> The check ioctls would be very very useful, IMHO.  Many filesystem tools
> refuse to operate on a mounted filesystem, but in some cases it'd be
> safe to do readonly operations on a frozen, mounted fs.
>   

Yep, and HA software would benefit from the check ioctls too.

- Fernando
