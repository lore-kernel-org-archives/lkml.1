Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZDGRim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZDGRim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbZDGRi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:38:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52166 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZDGRi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:38:28 -0400
Message-ID: <49DB8F8E.9010605@garzik.org>
Date: Tue, 07 Apr 2009 13:38:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Oleg Drokin <green@linuxhacker.ru>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Attempt at "stat light" implementation
References: <20090407062356.GA1336463@fiona.linuxhacker.ru> <20090407173248.GC31824@shareable.org>
In-Reply-To: <20090407173248.GC31824@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Once you have fine-grained selection of stat fields - it's natural to
> ask why not allow _additional_ stat fields in an future-extensible
> fashion?  A few things would be handy sometimes, such as inode
> generation number, modification generation number (to detect changes
> across reboots), and extra flags indicating COW or other properties.

That's quite an interesting thought...  until you run out of flags, the 
stat structure becomes a bit more flexible.

	Jeff



