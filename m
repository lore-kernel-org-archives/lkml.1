Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbXJRJmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbXJRJmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbXJRJmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:42:33 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:37049 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756084AbXJRJmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:42:32 -0400
Date: Thu, 18 Oct 2007 11:42:30 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
Message-ID: <20071018094230.GA2978@codeblau.de>
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com> <20071017220019.GA22765@codeblau.de> <471689BF.2040909@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471689BF.2040909@hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the packet trace was a bit too cooked perhaps, but there were indications 
> that at times the TCP window was going to zero - perhaps something with 
> window updates or persist timers?

Does TCP use different window sizes on loopback?  Why is this not
happening on ethernet?

How could I test this theory?

My initial idea was that it has something todo with the different MTU on
loopback.  My initial block size was 16k, but the problem stayed when I
changed it to 64k.

Felix
