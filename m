Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXCYTTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXCYTTD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXCYTTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:19:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXCYTTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:19:00 -0400
Date: Sun, 25 Mar 2007 15:18:45 -0400
From: Dave Jones <davej@redhat.com>
To: Helmut Auer <vdr@helmutauer.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 2.6.20 takes a long time to load
Message-ID: <20070325191845.GA11307@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Helmut Auer <vdr@helmutauer.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <46066970.20802@helmutauer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46066970.20802@helmutauer.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 02:22:08PM +0200, Helmut Auer wrote:
 > Hello List,
 > 
 > The kernel 2.6.20 makes a long delay during booting ( about 15 seconds ) after showing:
 > 
 > NET: Registered protocol family 2
 > 
 > then it goes along with:
 > 
 > IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
 > TCP established hash table entries: 8192 (order: 4, 98304 bytes)
 > ...
 > 
 > I am using the kernel parameter lpj to avoid calculating processor speed during kernel load.
 > If I do not use the lpj parameter, the detection of cpu speed takes about 10 seconds, but then 
 > there is no delay after:
 > NET: Registered protocol family 2
 > 
 > Any hints what I can try to get a fast booting kernel ?
 > I am using 2.6.20 with some gentoo patches ( plain 2.6.20-4 has the same problem ).

booting with initcall_debug will tell you the last thing it initialised before
the pause, which may give some clues.  Alternatively, git bisect ?

	Dave

-- 
http://www.codemonkey.org.uk
