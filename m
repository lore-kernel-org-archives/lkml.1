Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYKGTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYKGTCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKGTCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:02:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:02:23 -0500
Message-ID: <49148F94.2080303@zytor.com>
Date: Fri, 07 Nov 2008 10:57:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
In-Reply-To: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, if you could execute the following commands and include the output:

nm arch/x86/vdso/vdso32-sysenter.so.dbg
nm arch/x86/vdso/vdso32-int80.so.dbg

My guess at this point is a bug in nm.

	-hpa
