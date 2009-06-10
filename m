Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZFJRV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZFJRV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZFJRVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:21:52 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:53146 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbZFJRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:21:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJiIL0pR9cDZ/2dsb2JhbADRCgiEBQU
Date: Wed, 10 Jun 2009 19:21:52 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Vasily Averin <vvs@openvz.org>
Subject: Re: [PATCH 1/1] [WATCHDOG] fix memory corruption when RCBA is
	disabled by hardware
Message-ID: <20090610172152.GJ16090@infomag.iguana.be>
References: <1244200388-17933-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244200388-17933-1-git-send-email-den@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

> According to 9.1.33 on p.343 of ICH8.pdf RCBA can be disabled by
> hardware if bit 0 of RCBA register is not set.
> 
> Perform correct check for this to prevent memory corruption under
> some virtual machines where this feature is disabled.

Patch went in the watchdog-next tree.

Thanks,
Wim.

