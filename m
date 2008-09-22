Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYIVWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYIVWHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYIVWH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:07:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYIVWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:07:28 -0400
Message-ID: <48D81705.1030806@zytor.com>
Date: Mon, 22 Sep 2008 15:07:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure
References: <20080922210928.GE222374@sgi.com>
In-Reply-To: <20080922210928.GE222374@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
> +	if (tab->function == (unsigned long)NULL)

Preferred style is:

	if (!tab->function)

	-hpa
