Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYEAMv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYEAMv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbYEAMvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:51:19 -0400
Received: from mx1.ukfsn.org ([77.75.108.10]:43297 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbYEAMvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:51:18 -0400
Message-ID: <4819BCC4.8030504@dgreaves.com>
Date: Thu, 01 May 2008 13:51:16 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: alex14641@yahoo.com
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
In-Reply-To: <771640.4981.qm@web50209.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Davis wrote:
> Is this a bad thing? I'm guessing that it is, but I want independent
> confirmation before I spoke to someone I know who's doing this.
> 
> Thanks
Depends what you're trying to do.

It has the potential to increase i/o contention so it's not going to be a
performance win. Many systems really don't need to worry about performance. But
if you have 2x250 Gb drives and 1x500 Gb drive then your data is at less risk if
you partition the 500Gb into 2x250Gb and then mirror each partition with a full
250Gb disk. That would be a perfectly rational setup in many instances.

Equally, md has a mechanism to share hot spares amongst multiple RAIDs - but I
doubt that's what you meant.

David


