Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbYDPR7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbYDPR7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYDPR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:59:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:48508 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbYDPR7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UrZQuz3TCVXaKXo0A27kqWG1MmMbHBnMH8cDPJfH3Ve4sq+JNRVlPco3aeNws/E55huwDc2Mhrlp0RK15lrVDQxoqZVcFj4WZSNAZr4j6ZbbfQYsOp4ZxQVtLPlMPICEoERUasS3AWA8RvuHdcVnvYbhKp0G5gGBi9JiABkgWtQ=
Message-ID: <bb145bd20804161059u4fe45debs22adf337fef143aa@mail.gmail.com>
Date: Wed, 16 Apr 2008 19:59:24 +0200
From: "Christian Pernegger" <pernegger@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: Western Digital GreenPower drives and Linux
Cc: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4805E59E.1020607@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804092118.35501.tvrtko@ursulin.net>
	 <4805E59E.1020607@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > At this rate the disk would reach it's design limit for load/unload cycles
> in around 80 days.

Design *minimum* for load/unload cycles is reportedly 600K cycles,
that would give me over 7.5 years of 24/7 operation, which I can live
with in cheap high capacity drives that have only 5 years of warranty
anyway.

Support wouldn't say if the behavior is considered normal, though ...

Will set the timeout to 25sec using the DOS kludge and see what
happens ... doubt it will help much, though. I'd much rather like to
know what causes the drives to load heads again so soon after the
unload. With the usage pattern of these drives they should stay
unloaded most of the time here.

Being able to set the timeout online via hdparm would be nice, too :)

C.
