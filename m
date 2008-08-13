Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYHMUT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYHMUT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYHMUTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:19:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:37052 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755497AbYHMUTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:19:11 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19/aPonNSt/APnx0CSEHG5KU1RJoEtHJtrKl4HXr5
	MwAhIfcLGeHRed
Date: Wed, 13 Aug 2008 22:19:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: John Kacur <jkacur@gmail.com>, Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: drop overzealous ERROR: do not initialise statics to 0 or NULL
 from checkpatch.pl
In-Reply-To: <200808131415.36851.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0808132216460.7713@axis700.grange>
References: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
 <200808131415.36851.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, John Kacur wrote:

> Could we drop this somewhat overzealous "ERROR: do not initialise
> statics to 0 or NULL" from checkpatch.pl?
> 
> Reasoning:
> 1. This is not part of Documentation/CodingStyle
> 2. K&R 2nd.ed do it (pg 83, static int bufp = 0;) The purpose is to
> remove access to the bufp from external routines, and to avoid name
> conflict)

No, "static" "removes access to the bufp from external routines, and 
avoids name conflict", not the initialization to 0.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
