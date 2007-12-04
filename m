Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXLDTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXLDTNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXLDTNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:13:00 -0500
Received: from main.gmane.org ([80.91.229.2]:36015 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXLDTNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:13:00 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@asu.edu>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Tue, 4 Dec 2007 18:49:40 +0000 (UTC)
Message-ID: <loom.20071204T184742-19@post.gmane.org>
References: <20071204114125.GA17310@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 63.226.32.16 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.10) Gecko/20071115 Firefox/2.0.0.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Haber <mh+linux-kernel <at> zugschlus.de> writes:

> 
> While debugging Exim4's GnuTLS interface, I recently found out that
> reading from /dev/urandom depletes entropy as much as reading from
> /dev/random would. This has somehow surprised me since I have always
> believed that /dev/urandom has lower quality entropy than /dev/random,
> but lots of it.
> 
> This also means that I can "sabotage" applications reading from
> /dev/random just by continuously reading from /dev/urandom, even not
> meaning to do any harm.

An application either needs to be cryptographically secure, or it doesn't. If it
doesn't, then just use /dev/urandom to seed a PRNG.



