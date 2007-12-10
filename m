Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXLJOq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXLJOq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXLJOqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:46:48 -0500
Received: from baikonur.stro.at ([213.239.196.228]:58298 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXLJOqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:46:47 -0500
Date: Mon, 10 Dec 2007 15:46:39 +0100
From: maximilian attems <max@stro.at>
To: Ken Simon <ninkendo@gmail.com>
Cc: klibc@zytor.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: klibc ipconfig misbehavior in a network with DHCP snooping
Message-ID: <20071210144639.GB16790@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added klibc ml to cc ]

> I found a problem with klibc's "ipconfig" program, or at least, behavior
> that breaks DHCP on my thin clients (LTSP 5.0). It has to do with setting
> the giaddr field on dhcp_send in dhcp_proto.c, line 164.

thank you for digging into it.

>  Otherwise, the relay agent SHALL forward any received DHCP packet
>  with a valid non-zero giaddr WITHOUT adding any relay agent options.
>  Per RFC 2131 <
>  ;http://www.faqs.org/rfcs /rfc2131.html>, it shall also NOT modify the
>  giaddr value.

got also a single klibc Debian bug report on it:
-> http://bugs.debian.org/432977

i'm adding the patch to my branch and will submit it to hpa asap.


-- 
maks
