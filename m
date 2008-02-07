Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYBGLDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYBGLDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 06:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYBGLCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 06:02:54 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17332 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYBGLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 06:02:53 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOPS in sysctl.c
Date: Thu, 7 Feb 2008 12:02:45 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <200802050845.58691.hs4233@mail.mn-solutions.de> <200802051224.56413.hs4233@mail.mn-solutions.de> <20080206002420.91124dab.akpm@linux-foundation.org>
In-Reply-To: <20080206002420.91124dab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071202.45814.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> erp.  We'd really like to know what we did to fix it, and then
> get that fix back into 2.6.24.x.

Agreed :-)


One more finding: after turning off CONFIG_SLUB and usng 
CONFIG_SLAB instead, I cannot reproduce the bug.

Also, a quite bit Qt-Embedded 3.x programm survives without any 
trouble the suspend/resume. So I think that I don't have a 
general memory corruption problem. This is however just a 
feeling, not an evidence.

