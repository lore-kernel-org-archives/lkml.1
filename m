Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYHXIis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYHXIis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYHXIik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:38:40 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:34888 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYHXIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:38:39 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fix oops in acer_wmi
Date: Sun, 24 Aug 2008 09:38:28 +0100
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080823140509.4b197021@infradead.org> <200808240219.41946.carlos@strangeworlds.co.uk> <20080823214521.3d6e2f8c@infradead.org>
In-Reply-To: <20080823214521.3d6e2f8c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240938.29298.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sun, 24 Aug 2008 08:38:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2008 05:45:21 Arjan van de Ven wrote:
> interesting; I have no reports of this in kerneloops.org (but if this got
> introduced in 2.6.26 that's possible; there's not that many 2.6.26 users
> yet); you can see this yourself at
> http://www.kerneloops.org/search.php?search=acer_wmi_init
> on the left side it shows how often it happens for which versions/
>
> I'll still call it a tentative regression ;=)

My bad; this is just a 2.6.27 regression - I thought the offending patch that 
had caused this (83097aca8567a0bd593534853b71fe0fa9a75d69) went into 2.6.26 
as well, it didn't.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
