Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYHHJw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYHHJw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYHHJwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:52:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:8302 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYHHJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:52:48 -0400
X-IronPort-AV: E=Sophos;i="4.31,327,1215388800"; 
   d="scan'208";a="1334191"
Message-ID: <489C17C3.6060006@eu.citrix.com>
Date: Fri, 08 Aug 2008 10:54:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] [RESEND] fbcon: simple text blinking
 implementation
References: <487F4E20.6090802@eu.citrix.com> <Pine.LNX.4.64.0807172047340.20605@anakin>
In-Reply-To: <Pine.LNX.4.64.0807172047340.20605@anakin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2008 09:52:47.0591 (UTC) FILETIME=[83476F70:01C8F93C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> On Thu, 17 Jul 2008, Stefano Stabellini wrote:
>> at the moment blinking is not supported in fbcon but it is supported in
>> vgacon.
>> Since userspace applications don't distinguish between the two, they just
>> assume that the linux terminal is always capable of blinking text.
>> However implementing blinking in fbcon is not so difficult: this patch
>> provides a very simple (too simple?) implementation of that.
>> I am using the flashcursor function to scan the buffer for blinking text.
>> For the sake of efficiency I added a simple flag mechanism to disable the scan
>> when I am sure that there are no blinking characters on the screen.
> 
> Ehrm, there's already blinking support on some platforms?
> 

are you sure?
fbcon isn't supposed to be a software implementation?
