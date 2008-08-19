Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYHSXb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYHSXb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYHSXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:30:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYHSXau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:30:50 -0400
Message-ID: <48AB55CE.30607@zytor.com>
Date: Tue, 19 Aug 2008 16:22:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/10] LinuxPPS core support.
References: <> <1219182612-13814-1-git-send-email-giometti@linux.it> <1219182612-13814-2-git-send-email-giometti@linux.it>
In-Reply-To: <1219182612-13814-2-git-send-email-giometti@linux.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
>  'P'	all	linux/soundcard.h
> +'P'	00-04	linux/pps.h		LinuxPPS
> +					<mailto:giometti@linux.it>

This represents a reservation conflict even if it doesn't represent an 
actual conflict.  If it is a reservation conflict only, please adjust 
the range reserved for soundcards (and verify with the sound maintainers 
that it's okay to do so); if it's an actual conflict please reassign.

	-hpa
