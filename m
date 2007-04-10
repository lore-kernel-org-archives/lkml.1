Return-Path: <linux-kernel-owner+w=401wt.eu-S1031241AbXDJRbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241AbXDJRbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031249AbXDJRbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:31:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031241AbXDJRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:31:21 -0400
Message-ID: <461BC9DE.5030009@zytor.com>
Date: Tue, 10 Apr 2007 10:31:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Clean up x86 control register and MSR macros
References: <200704101648.l3AGmT5e027601@tazenda.hos.anvin.org> <461BC350.4040403@goop.org>
In-Reply-To: <461BC350.4040403@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Is having separate bit numbers and masks useful?  If so, is it worth
> doing for the others?
> 

I presume it's useful, or at least *used* in the current code, since 
that was there already.  If deemed useful, it's something we could add 
to the other bitmasks.

	-hpa
