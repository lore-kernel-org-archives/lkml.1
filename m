Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbYD1Gcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbYD1Gcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYD1Gci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:32:38 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:36499 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYD1Gci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:32:38 -0400
Message-ID: <48156F7C.3080402@bfh.ch>
Date: Mon, 28 Apr 2008 08:32:28 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
References: <20080427.174536.62560212.davem@davemloft.net> <20080427215840.0961be81@laptopd505.fenrus.org>
In-Reply-To: <20080427215840.0961be81@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 06:31:51.0737 (UTC) FILETIME=[8B4B9A90:01C8A8F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
[snip]
> how far would "if you DEPENDS on FOO, and FOO is =m, you can only be =m or =n" get us?
> or are there hidden traps on this?
> (the hard case is if a non-tristate DEPENDS on a tristate, but... that's a trap anyway)
I guess it depends on the (use-)case. But in general I'd like a system 
like that, especially if it would spew out warnings and errors for cases 
like the one mentioned.
