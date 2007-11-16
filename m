Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXKPSkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXKPSkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:40:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXKPSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:39:53 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:8182 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXKPSjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:39:53 -0500
Message-ID: <473DE3C8.9060009@hp.com>
Date: Fri, 16 Nov 2007 13:39:04 -0500
From: "Alan D. Brunelle" <alan.brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       arjan@infradead.org, jens.axboe@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>	 <20071015114738.6b5a25c7.akpm@linux-foundation.org>	 <20071015161315.4fe18e07@bree.surriel.com>	 <20071015141236.62b075c6.akpm@linux-foundation.org>	 <473B18BA.5000709@hp.com>	 <20071114091451.d4b110db.akpm@linux-foundation.org>	 <473DC496.6010805@hp.com> <2c0942db0711161035x5978a37bjd0f3fb67470553eb@mail.gmail.com>
In-Reply-To: <2c0942db0711161035x5978a37bjd0f3fb67470553eb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> 
> Out of curiosity, what are the mount options for the freshly created
> ext3 fs? In particular, are you using noatime, nodiratime?
> 
> Ray

Nope, just mount. However, the tool I'm using to read the large file & 
overwrite the large file does open with O_NOATIME for reads...

The tool used to read the files in the read-a-tree test is dd, and I 
doubt(?) it does a O_NOATIME...

Alan
