Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYBDOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYBDOz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYBDOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:55:21 -0500
Received: from styx.suse.cz ([82.119.242.94]:55053 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751219AbYBDOzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:55:20 -0500
Date: Mon, 4 Feb 2008 15:55:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080204132853.GA4630@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802041554030.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
 <20080204132853.GA4630@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Pavel Machek wrote:

> Not sure this helps... If I only randomize _end_ of heap, it still 
> works. If I try to randomize beggining of heap, too, it will not even 
> start recent binaries :-(.

I don't uderstand this, sorry. Ehen the mapping for the new process is 
being established during loading of the binary, the beginning and the end 
of the heap are the same ...

-- 
Jiri Kosina
