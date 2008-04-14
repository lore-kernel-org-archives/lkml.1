Return-Path: <linux-kernel-owner+w=401wt.eu-S1762659AbYDNQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659AbYDNQyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbYDNQyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:54:41 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.17]:47791 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYDNQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:54:40 -0400
Date: Mon, 14 Apr 2008 18:54:22 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Again... DMA speed too slow
Message-ID: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Apr 2008 16:54:22.0087 (UTC) FILETIME=[300E3970:01C89E50]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Which controller are you on?  I bet the recording itself will work fine
>on 48x.  It's probably that READ/WRITE BUFFERs are executed using PIO
>for compatibility reasons. 

If this happens inside Linux, Linux should be changed...

but note that wodim is based on 3 year old cdrecord code and cdrecord
is constantly evolving. A lot of problems in cdrecord have been fixed during 
the last years while wodim still uses the old code. If you like to judge you 
first should upgrade to a recent original cdrtools from:

ftp://ftp.berlios.de/pub/cdrecord/alpha/

2.01.01a38 is the latest. Install cdrecord suid root and try again.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
