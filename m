Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbXGNI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbXGNI5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXGNI5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:57:10 -0400
Received: from smtp.qwerty.ru ([87.240.2.134]:59739 "EHLO smtp.qwerty.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXGNI5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:57:09 -0400
Date: Sat, 14 Jul 2007 12:57:08 +0400
From: Kirill Kuvaldin <kuvkir@epsmu.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isofs: mounting to regular file may succeed
Message-ID: <20070714085708.GA17652@zetta.epsmu.com>
References: <20070713234721.GG4536@zetta.epsmu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713234721.GG4536@zetta.epsmu.com>
Organization: EpsMu Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 03:47:21AM +0400, Kirill Kuvaldin wrote:
> $ dd if=correct.iso of=bad.iso bs=4k count=8

Oops, sorry, the right command should be:

dd if=correct.iso of=bad.iso bs=4k seek=8
                                   ^^^^
 

Kirill
