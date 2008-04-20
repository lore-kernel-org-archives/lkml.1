Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYDTRag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYDTRag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYDTRa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:30:28 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:60353 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYDTRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:30:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=foO6AODwvtj8dKcZxFK9Rs5iRTfCRxA27kALYRT8Y+kKY+ozASnpdKieFfAVwu/XN3g7hgeIL6ofGgg9g7XgZ91WJ+A0UdxMNk5oXd70a/FEj0d4GQIf/4VjiXrqcPZY0uq5zDopgl2C3OX0FcOGRrvke7DFbTRniuSFMD7zp1Q=;
Message-ID: <480B7D72.7020503@unsolicited.net>
Date: Sun, 20 Apr 2008 18:29:22 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
References: <46016.36939.qm@web36608.mail.mud.yahoo.com>
In-Reply-To: <46016.36939.qm@web36608.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Do you have a libcap that reflects the change from 32 capabilities
> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
>   
Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm now 
running normally, thanks!

Was this userspace visible change planned in advance for 2.6.25 ? ... as 
I guess a few other people with venerable old userspace components may 
come across this issue.

Cheers
David
