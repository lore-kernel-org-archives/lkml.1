Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXCVO57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXCVO57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 10:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXCVO57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 10:57:59 -0400
Received: from relay4.usu.ru ([194.226.235.39]:60787 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010AbXCVO56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 10:57:58 -0400
Message-ID: <46029985.8080705@ums.usu.ru>
Date: Thu, 22 Mar 2007 19:58:13 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <Pine.LNX.4.64.0703221350400.14458@scrub.home> <46028303.7070104@ums.usu.ru> <Pine.LNX.4.64.0703221438050.14457@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0703221438050.14457@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:

> hfs has a codepage option as well

Is it _currently_ useful at all? The problem is that the kernel has no nls 
modules for Mac codepages (e.g., MacRoman which is cp10000).

-- 
Alexander E. Patrakov
