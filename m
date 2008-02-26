Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYBZFFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYBZFFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYBZFF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:05:26 -0500
Received: from ozlabs.org ([203.10.76.45]:41634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYBZFF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:05:26 -0500
Date: Mon, 25 Feb 2008 23:03:58 -0600
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080226050358.GB17772@kryten>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <1203531375.6243.52.camel@lappy> <20080220103940.0a0b5ce0@laptopd505.fenrus.org> <1203533622.6243.55.camel@lappy> <1203533885.6243.60.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203533885.6243.60.camel@lappy>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter,
 
> Usable for me is a cli interface. Also, I absolutely love opannotate.

I definitely agree there.

It's interesting to note that sysprof requires you to run the GUI as
root in order to work. Maybe Ingo and Arjan are confident there are no
bugs in all the libraries that sysprof links to:

# ldd `which sysprof` | wc -l
39

I'm not.

Actually before someone converted it to debugfs, it was even worse, the
sysprof kernel module exported all profiling information to the world:

-r--r--r-- 1 root root 2060 2008-02-25 23:00 /proc/sysprof-trace

Anton
