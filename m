Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXCAWQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXCAWQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161002AbXCAWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:16:04 -0500
Received: from gw.goop.org ([64.81.55.164]:38573 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161001AbXCAWQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:16:01 -0500
Message-ID: <45E7509E.7090000@goop.org>
Date: Thu, 01 Mar 2007 14:15:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com>	<20070225022326.137b4875.akpm@linux-foundation.org>	<20070301183445.GA7911@amitarora.in.ibm.com>	<45E74238.3040606@goop.org>	<20070301225855.24ecaba0@lxorguk.ukuu.org.uk>	<45E74E30.8080909@goop.org> <20070301231118.427544a4@lxorguk.ukuu.org.uk>
In-Reply-To: <20070301231118.427544a4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> ENOSYS indicates quite different things and ENOTTY is also used for
> syscalls. I still think ENOTTY is correct.
>   
Yes, ENOSYS tends to me "operation flat out not support" rather than
"not on this object".  I think we can do better than ENOTTY though -
ENOTSUP for example (modulo the confusion over EOPNOTSUPP).

(You can tell the patch has very little real substance if we're arguing
over errnos at this point :)

    J
