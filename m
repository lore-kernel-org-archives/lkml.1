Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXFWLBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXFWLBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXFWLAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:00:38 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:46365 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbXFWLAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:00:37 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 13:00:18 +0200
User-Agent: KMail/1.9.7
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <200706231245.30317.info@gnebu.es> <20070623105057.GD7070@1wt.eu>
In-Reply-To: <20070623105057.GD7070@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231300.18840.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Willy Tarreau wrote:
> On Sat, Jun 23, 2007 at 12:45:30PM +0200, Alberto Gonzalez wrote:
> > Ok, so if I understand correctly, the problem I had in my simple test
> > will be solved by distributions once a fair scheduler goes into mainline?
>
> No, there is no reason to wait for a fair scheduler at all. A *desktop*
> distro *must* take process priorities into account, otherwise it's broken
> by design.

Well, right now with the mainline scheduler it works fine. The player gets 
more CPU time than the encoder. It was when I switched to -ck kernel (with a 
fair scheduler) that it didn't work correctly, that's why I asked about 
this "fair" concept in the first place.

I guess once a fair scheduler goes mainline they will adapt things to work 
correctly again.

> Regards,
> Willy

Cheers,
Alberto.


