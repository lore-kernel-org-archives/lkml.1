Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYAISFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYAISFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYAISFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:05:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYAISFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:05:13 -0500
Message-ID: <47850C89.2040805@zytor.com>
Date: Wed, 09 Jan 2008 10:03:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Oeser <ioe-lkml@rameria.de>, Andi Kleen <andi@firstfloor.org>,
       Bernd Schubert <bernd-schubert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: sleep before boot panic
References: <200801061908.43010.bernd-schubert@gmx.de> <p731w8ts70k.fsf@bingen.suse.de> <200801080717.03467.ioe-lkml@rameria.de> <47831D97.7040908@zytor.com> <20080108160645.GA4574@ucw.cz>
In-Reply-To: <20080108160645.GA4574@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
>> Of course, if we'd been using kinit, "soft panic" would 
>> have been done exclusively in userspace...
> 
> What's the status of kinit, btw?
> 							Pavel

It's bitrotted a bit since it was first rejected.  It wouldn't take too 
much work to bring it back up to speed, however.  klibc, and some of the 
kinit components, are used for the initramfs in Debian.

	-hpa
