Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbZD2RQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbZD2RQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZD2RPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:15:55 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58099 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbZD2RPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:15:54 -0400
Date: Wed, 29 Apr 2009 13:15:54 -0400
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Debug only with printk ?
Message-ID: <20090429171553.GC21465@csclub.uwaterloo.ca>
References: <2d05c4580904281427r65282bb2m5dd8c9f8a2de5363@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d05c4580904281427r65282bb2m5dd8c9f8a2de5363@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 11:27:42PM +0200, Dragoslav Zaric wrote:
> I am relatively new in linux kernel and since debugging is key
> element of programming, I am wondering is it really necessary
> to use various debugging tools for kernel debugging ?
> 
> Is simple printing with printk enough to debug any kind of kernel problem,
> and if not, what are the cases when printk is not enough ?
> 
> Also, is there possibility when using debugging tools to affect
> kernel environment, because debugging tool will also take cpu time and
> memory resources ?

So far I have used printk's, parsing of the OOPS when I do something
stupid, educated guesing looking at the code following an OOPS or other
problem, and in a couple of cases using firescope.  I have used firescope
to monitor the DMA ring buffer for the pcnet32 driver once.

-- 
Len Sorensen
