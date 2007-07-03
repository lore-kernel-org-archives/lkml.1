Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXGCGOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXGCGOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXGCGN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:13:58 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:38320 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXGCGN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:13:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 08:13:53 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org>
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030813.53481.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Matthew Garrett:
> Suspend to RAM on a machine with / on a fuse filesystem turns out to be 
> a screaming nightmare - either the suspend fails because syslog (for 
> instance) can't be frozen, or the machine deadlocks for some other 
> reason I haven't tracked down. We could "fix" fuse, or alternatively we 
> could do what we do for suspend to RAM on other platforms (PPC and APM) 
> and just not use the freezer.

Only if you want to audit all character devices' read() and write()
methods for races against suspend().
/ on fuse is a bad idea.

	Regards
		Oliver

