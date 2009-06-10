Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbZFJUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbZFJUwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760337AbZFJUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:52:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbZFJUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:52:09 -0400
Message-ID: <4A301CCD.7070707@zytor.com>
Date: Wed, 10 Jun 2009 13:51:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, renton@renton.name,
       linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru>	<4A26EB18.6060907@zytor.com>	<20090609161945.811cc01f.akpm@linux-foundation.org>	<2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <20090609165304.add1a872.akpm@linux-foundation.org>
In-Reply-To: <20090609165304.add1a872.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> hm, OK.
> 
> I've now mounted 15000 devpts's and still no slowdown is evident.

I ran my test script, mounting ramfs, with n=100000, and well, gave up
since it hadn't gotten any further than 57000 or so overnight.  At that
time each individual mount was taking several seconds.

Graphing the delays seem to indicate O(n^2) behavior.

umounts do not appear affected; each umount still take negible time.

	-hpa

