Return-Path: <linux-kernel-owner+w=401wt.eu-S1161818AbXEATUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161818AbXEATUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161819AbXEATUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:41800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161818AbXEATUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:20:37 -0400
Date: Tue, 1 May 2007 21:20:36 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070501192036.GA2117@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070430084833.GA16173@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

* Vivek Goyal <vgoyal@in.ibm.com> [2007-04-30 10:48]:
> > 
> handle_edge_irq() already makes sure that desc->action is not null, still
> note_interrupt() is receiving desc->action as null, that's strange. On my 
> system this is happening for irq 4 and /proc/interrupt shows that it is
> coming from "serial".

from reading the code I also cannot this. However, I'm trying to
reproduce the problem here. I hope I find a machine where this also 
happens.


Thanks,
   Bernhard
-- 
SUSE LINUX Products GmbH          Tel. +49 (911) 74053-0
Maxfeldstr. 5                     GF: Markus Rex
90409 Nürnberg, Germany           HRB 16746 (AG Nürnberg)
OpenPGP DDAF6454: F61F 34CC 09CA FB82 C9F6  BA4B 8865 3696 DDAF 6454
