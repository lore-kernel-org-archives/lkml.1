Return-Path: <linux-kernel-owner+w=401wt.eu-S1030417AbXCAWFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbXCAWFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030411AbXCAWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:05:41 -0500
Received: from gw.goop.org ([64.81.55.164]:40396 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030377AbXCAWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:05:39 -0500
Message-ID: <45E74E30.8080909@goop.org>
Date: Thu, 01 Mar 2007 14:05:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com>	<20070225022326.137b4875.akpm@linux-foundation.org>	<20070301183445.GA7911@amitarora.in.ibm.com>	<45E74238.3040606@goop.org> <20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
In-Reply-To: <20070301225855.24ecaba0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> A lot of people get confused about -ENOTTY, but it is the return for
> attempting to use an ioctl on the wrong type of object, so this appears
> to be quite correct.

This is a syscall though; ENOSYS is probably a better match.

    J
