Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbZBZALK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbZBZALK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763423AbZBZAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:10:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZBZAKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:10:52 -0500
Message-ID: <49A5DDF7.9070301@zytor.com>
Date: Wed, 25 Feb 2009 16:10:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<49A5D76A.3010301@zytor.com> <yq11vtmhy0x.fsf@sermon.lab.mkp.net>	<49A5DAE7.3060409@zytor.com> <yq1skm2giwa.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1skm2giwa.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
> 
> hpa> Why one-time?
> 
> It's a compromise to avoid hours of low-level formatting before you can
> use a drive.  New drives will come from the factory formatted in a
> special way that can be switched instantaneously.  But once you start
> writing you're stuck with it.
> 

That's ridiculously stupid.  All you need is an offset parameter, which 
can be flipped at will.  Now, flipping it will obviously scramble all 
data, but there is absolutely no reason why it shouldn't be possible to 
instantaneously flip it back and forth.

	-hpa
