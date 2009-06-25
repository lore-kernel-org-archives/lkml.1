Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbZFYIGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbZFYIGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZFYIGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:06:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:35825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZFYIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:06:06 -0400
Subject: Re: Add support for the SST 39VF3202, 39VF6401B and 39VF6402B
 flash chips
From: David Woodhouse <dwmw2@infradead.org>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f69abfc30906250042g4e6cec13n1a25f4b04ce5177c@mail.gmail.com>
References: <f69abfc30906250042g4e6cec13n1a25f4b04ce5177c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 09:06:07 +0100
Message-Id: <1245917167.17089.102.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 09:42 +0200, Yegor Yefremov wrote:
> Add support for the SST 39VF3202, 39VF6401B and 39VF6402B flash chips
> 
> - extend struct amd_flash_info to enable 8 erase regions for 8Mb flash chips

If you didn't mean 8,000,000 bits, don't say it. Did you mean 8MiB?

> - change erase block command to 0x50 due to the differences between
> 39VF6401/02 and 39VF6401B/02B chips

Hm, can you elucidate? And should that be done as a quirk instead?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

