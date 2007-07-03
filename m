Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbXGCHo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbXGCHo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXGCHoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:44:22 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:43136 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXGCHoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:44:21 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 09:44:18 +0200
User-Agent: KMail/1.9.7
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707031608.06348.nigel@nigel.suspend2.net> <1183447184.10386.102.camel@localhost.localdomain>
In-Reply-To: <1183447184.10386.102.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707030944.18702.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> So to summarize, the plan that makes things work with fuse is:
> 
>  - For STR, don't do the freezer thing.
> 
>  - For STD, don't sys_sync() after you froze
> 
> There might be -other- issues, but that should get you through some of

At the risk of repeating myself. Character device drivers are written
with the assumption that normal io and suspend/resume do not race
with each other due to the freezer.
What do you intend to do about that?

	Regards
		Oliver

