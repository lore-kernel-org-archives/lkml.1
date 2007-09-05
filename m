Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbXIET4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbXIET4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbXIET4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:56:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbXIET4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:56:04 -0400
Message-ID: <46DF09CA.9090500@redhat.com>
Date: Wed, 05 Sep 2007 15:55:54 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: modinfo <modulename> question
References: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Is there anyway to get/see what parameters were passed to a kernel 
> module? Running modinfo -p <module> will show the defaults, but for 
> example, st, the scsi tape driver, is there a way to see what it is 
> currently using? I know in dmesg it shows this when you load it 
> initially (but if say dmesg has been cleared or the buffer was filled up)?

/sys/module/$MODULENAME/parameters/
