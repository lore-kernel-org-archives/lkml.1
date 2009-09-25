Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZIYOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZIYOqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZIYOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:46:33 -0400
Received: from james.oetiker.ch ([213.144.138.195]:39422 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbZIYOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:46:32 -0400
Date: Fri, 25 Sep 2009 16:46:34 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Corrado Zoccolo <czoccolo@gmail.com>
cc: Shan Wei <shanwei@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [RFC] cfq: adapt slice to number of processes doing I/O
 (v2.1)]
In-Reply-To: <4e5e476b0909250105m18983420g20e39cb2b124af04@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909251501310.13144@sebohet.brgvxre.pu>
References: <4AB74629.1030109@cn.fujitsu.com> <4ABB3A0E.2090204@cn.fujitsu.com> <4e5e476b0909250105m18983420g20e39cb2b124af04@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corrado,


> > Have you tested buffered write, multi-threads?
> Yes. One interesting test was done by Tobias Oetiker
> (http://oss.oetiker.ch/optools/wiki/fsopbench) on his Areca HW Raid6
> with ext3. He put target_latency to 200ms, and used a lower
> slice_idle, to match his faster disks.

I have since updated my benchmark program:

  http://oss.oetiker.ch/optools/wiki/FsOpBench

it provides an even better competition model. It now works on a
20GB artificial file tree with a home directory like file
distribution. Results are quite striking ... (not necessarily
encouraging).

results are quite amazing ... I am still collecting ... but maybe
some of you want to try this too ...

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
