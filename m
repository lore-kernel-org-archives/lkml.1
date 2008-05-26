Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYEZOyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYEZOyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYEZOyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:54:38 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49919 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYEZOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:54:37 -0400
Message-ID: <483ACECA.8000905@s5r6.in-berlin.de>
Date: Mon, 26 May 2008 16:52:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu>
In-Reply-To: <20080526101646.GD24507@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> It is on my todo list, but I've been doing a lot of travelling, and
> when you have only one laptop, and pulling USB sticks isn't the sort
> of thing you can do using UML or KVM, it tends to fall to the bottom
> of your list.

Maybe add fault injection code which simply lets a SCSI LLD's
queuecommand fail everything when a sysfs switch was flipped.  There may
be more convenient points to fail IO higher up, I don't know.
-- 
Stefan Richter
-=====-==--- -=-= ==-=-
http://arcgraph.de/sr/
