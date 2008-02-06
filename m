Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYBFT2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYBFT2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYBFT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:27:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYBFT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:27:56 -0500
Message-ID: <47AA0A2E.30701@zytor.com>
Date: Wed, 06 Feb 2008 11:27:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0802061517380.8470@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 
> Don't forget that tmpfs overflows into swap, so you could save money
> by adding adding more swap and cutting down on the RAM: though of
> course that will perform very poorly once it's actually using the
> swap, probably not the direction you want to go in.
> 

It can still outperform conventional disk filesystems, however, mostly 
because it doesn't have to worry one iota about consistency.

	-hpa
