Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbZIPXSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbZIPXSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbZIPXSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:18:30 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:51627 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760298AbZIPXS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:18:29 -0400
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Epic regression in throughput since v2.6.23
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	<873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu>
	<87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu>
	<87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu>
	<87iqfmx3tr.fsf@depni.sinp.msu.ru> <20090916194507.GA27456@elte.hu>
Date: Wed, 16 Sep 2009 23:18:27 +0000
In-Reply-To: <20090916194507.GA27456@elte.hu> (Ingo Molnar's message of "Wed,
	16 Sep 2009 21:45:07 +0200")
Message-ID: <87fxamiim4.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Ok, i think we've got a handle on that finally - mind checking latest 
> -tip?

Kernel build benchmark:
http://img11.imageshack.us/img11/4544/makej20090916.png

I have also repeated video encode benchmarks described here:
http://article.gmane.org/gmane.linux.kernel/889444

"x264 --preset ultrafast":
http://img11.imageshack.us/img11/9020/ultrafast20090916.png

"x264 --preset medium":
http://img11.imageshack.us/img11/7729/medium20090916.png
