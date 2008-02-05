Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbYBEULo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbYBEULo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYBEULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:11:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYBEULd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:11:33 -0500
Message-ID: <47A8C2D8.3020603@zytor.com>
Date: Tue, 05 Feb 2008 12:11:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       michael.pyne@kdemail.net, AAbdulla@nvidia.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/4] forcedeth: fix MAC address detection on network card
 (regression in 2.6.23)
References: <200802050746.m157ktY9010399@imap1.linux-foundation.org> <47A8A90B.6010602@garzik.org> <47A8AD40.7010007@zytor.com> <47A8ADF9.7060507@garzik.org>
In-Reply-To: <47A8ADF9.7060507@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Indeed, that would work too...  though we would need to put out a call 
> for Gigabyte testers during 2.6.25-rc.
> 
> It is an entirely reasonable scenario for NVIDIA to deploy a fix to 
> Gigabyte, which would then return us to the same scenario we have today: 
>  some work and some don't.
> 
> That's my main reason for leaning more conservative here.
> 

If they deploy a fix, then the Gigabyte prefix will show up as a prefix, 
rather than a suffix - no problem.  That's actually the reason to deploy 
that solution rather than relying on DMI.

	-hpa
