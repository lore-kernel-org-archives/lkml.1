Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZEBQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZEBQwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZEBQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 12:52:06 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:4501 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZEBQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 12:52:05 -0400
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
To: deller@gmx.de (Helge Deller)
Date: Sat, 2 May 2009 12:52:01 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: kyle@mcmartin.ca, tabbott@MIT.EDU, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, andersk@MIT.EDU, wdaher@MIT.EDU,
       vda.linux@googlemail.com, jbarnold@MIT.EDU,
       linux-parisc@vger.kernel.org
In-Reply-To: <49FC71E6.4000100@gmx.de> from "Helge Deller" at May 2, 2009 06:16:38 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090502165202.7E4424FC6@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really meant that a > 8k alignment was not possible.
> I tried exactly the same stuff once and failed.
> I think the restriction came from hpux compatibility or some old gas...

The maximum alignment on hpux is 4k bytes.  This was implemented in
2004 in the PA backend for hpux.  Prior to that, the default for
MAX_OFILE_ALIGNMENT (BIGGEST_ALIGNMENT) was in effect for all PA
targets.  It looks like Carlos added the define to elfos.h in November
2006.  So unless this was back ported, 4.2.0 would be the first gcc
release to support large alignments on linux.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
