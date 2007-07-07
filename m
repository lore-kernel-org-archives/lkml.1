Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXGGUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXGGUe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbXGGUeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:34:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXGGUep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:34:45 -0400
Message-ID: <468FF8CD.9060205@redhat.com>
Date: Sat, 07 Jul 2007 16:34:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
References: <20070706222651.GG5777@v2.random> <Pine.LNX.4.64.0707072053160.1536@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707072053160.1536@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 7 2007 00:26, Andrea Arcangeli wrote:
>> Subject: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
> 
> I wonder what happens if the soft page size gets set to 2048 bytes :)

That won't work, because the smallest granularity the x86
MMU supports is 4kB.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
