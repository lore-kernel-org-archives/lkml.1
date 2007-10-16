Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXJPMP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXJPMP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 08:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXJPMPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 08:15:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:54936 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755020AbXJPMPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 08:15:12 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+E/yZFBY6Eu1oPWjNaB9N3Dl+Gpf3GV5vcvTkVmG
	asXvOShUjzw55i
From: Jan-Simon =?utf-8?q?M=C3=B6ller?= <dl9pf@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] memory leak in dm
Date: Tue, 16 Oct 2007 14:15:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <20071016113800.GA4631@luggage>
In-Reply-To: <20071016113800.GA4631@luggage>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161415.13018.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 16 Oktober 2007 13:38:00 schrieb Kristof Provost:
> Hi,
>
> I'm seeing a serious memory leak whenever I use my /home partition.
> It's an encrypted partition using dm-crypt. Simply running
> 'stress -d 5' is enough to exhaust the memory in a few minutes.

Same setup here - I can confirm the leak. Happened here while compiling latest 
kernel while using the previous build. Over 1GB "vanished" :D ... Now i'm 
back to the default kernel.

I'll apply the patch now and report.

Greets
Jan-Simon

