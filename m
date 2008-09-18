Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYIRRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYIRRK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYIRRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:10:13 -0400
Received: from ryu.zarb.org ([212.85.158.22]:50145 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYIRRKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:10:12 -0400
Subject: Re: edd breaking vesafb
From: Pascal Terjan <pterjan@mandriva.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48D2811B.8090602@zytor.com>
References: <1221751035.26693.8.camel@plop>  <48D2811B.8090602@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Thu, 18 Sep 2008 19:10:06 +0200
Message-Id: <1221757806.26693.14.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.92-1mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 septembre 2008 à 09:26 -0700, H. Peter Anvin a écrit :
> Pascal Terjan wrote:
> > Hello
> > 
> > I got a report of vesafb no longer working since edd is used on a
> > machine (Shuttle FN41SP).
> > It's a BIOS bug that was easily workarounded by calling set_video before
> > query_edd.
> > Does someone see some issue in doing that ?
> > 
> 
> Yes, it means that we won't get the status and error messages from 
> query_edd.  In fact, we changed the ordering specifically for this reason.

Indeed

> The VESA code and EDD code both use the boot code heap.  One could guess 
> that the problem is data left on the heap by the EDD code causing a 
> failure when combined with a bad BIOS.
> 
> Does this patch work for you?
> 

No it does not help

