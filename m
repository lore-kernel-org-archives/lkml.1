Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXF3ENd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXF3ENd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 00:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXF3ENZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 00:13:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXF3ENZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 00:13:25 -0400
Message-ID: <4685D6CC.9070007@zytor.com>
Date: Sat, 30 Jun 2007 00:06:36 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux@horizon.com
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ak@suse.de, bk@suse.de, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
References: <20070630030343.31711.qmail@science.horizon.com>
In-Reply-To: <20070630030343.31711.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
> 
> Anyway, the patch which introduces the problem is the aptly named 3ebad:
> 3ebad59056: [PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending
> 
> 2.6.22-rc6 plus that one commit reverted successfully does APM suspend
> (and resume) for me.

Okay, I would guess that that patch probably touches MTRRs without 
actually verify that the CPU *has* MTRRs -- the Transmeta Crusoe CPU 
doesn't have MTRRs.

	-hpa
