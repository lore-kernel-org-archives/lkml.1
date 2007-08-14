Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXHNKV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXHNKV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbXHNKQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:16:42 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51403 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213AbXHNKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:16:40 -0400
Message-ID: <46C18068.7020602@aitel.hist.no>
Date: Tue, 14 Aug 2007 12:14:00 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Adnan Khaleel <akhaleel2001@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Page Cache Question
References: <725937.57185.qm@web33705.mail.mud.yahoo.com>
In-Reply-To: <725937.57185.qm@web33705.mail.mud.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adnan Khaleel wrote:
> I'm looking for a way to disable the page cache for an
> experimental NUMA system running the 2.6.17 kernel. I would prefer to
> only disable the page cache for my process and still have it be enabled
> by the rest of the system. Is there an easy way of doing this?
> Alternatively, I would be fine disabling the Page Cache altogether as well.
>   
Assuming what you really mean is that you don't want to cache
file i/o for that process - try opening files with O_DIRECT.

Helge Hafting

