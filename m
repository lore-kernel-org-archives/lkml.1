Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZAMPRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZAMPRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZAMPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:17:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38313 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZAMPR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:17:27 -0500
Message-ID: <496CB076.8080002@garzik.org>
Date: Tue, 13 Jan 2009 10:17:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Benny Halevy <bhalevy@panasas.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       open-osd development <osd-dev@open-osd.org>,
       Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com> <4947C624.3050602@panasas.com> <4964CEA4.7080001@panasas.com> <20090113135526.28730314@lxorguk.ukuu.org.uk> <20090113150955.GA9636@shareable.org>
In-Reply-To: <20090113150955.GA9636@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Having one super block would be silly.

Yep.


> But aren't most kinds of replication better done behind the OSD level,
> on the storage fabric?  OSD is all about letting the fabric decide
> things like allocation and durability strategies after all.

Probably, but one cannot _assume_ that.  The OSD device might just be a 
dumb, non-replicated OSD simulator, or in the future, a singleton SATA 
drive.

	Jeff



