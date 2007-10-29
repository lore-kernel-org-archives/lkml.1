Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXJ2UBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXJ2UBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXJ2UBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:01:43 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:38463 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXJ2UBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:01:42 -0400
Message-ID: <47263C2C.3090409@zabbo.net>
Date: Mon, 29 Oct 2007 13:01:48 -0700
From: Zach Brown <zab@zabbo.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Mike Waychison <mikew@google.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>	<20071029101001.4378a7cf@think.oraclecorp.com>	<47260AB1.9000003@zabbo.net>	<472631FE.9070003@google.com> <20071029154657.04ddd13b@think.oraclecorp.com>
In-Reply-To: <20071029154657.04ddd13b@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But, we shouldn't inflict all of this on fibmap/fiemap....we'll get
> lost trying to make the one true interface for all operations.
> 
> For grouping operations on files, I think a read_tree syscall with
> hints for what userland will do (read, stat, delete, list
> filenames), and a better cookie than readdir should do it.

Agreed, on both points.

- z
