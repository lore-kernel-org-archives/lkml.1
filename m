Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXHHO2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXHHO2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXHHO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:28:41 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:38336 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbXHHO2k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:28:40 -0400
From: Laurent Pinchart <laurentp@cse-semaphore.com>
Organization: CSE Semaphore
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: Serial buffer memory leak
Date: Wed, 8 Aug 2007 16:28:36 +0200
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200708081158.06843.laurentp@cse-semaphore.com> <20070808144532.5e3a1998@the-village.bc.nu> <1186582307.3394.3.camel@x2.microgate.com>
In-Reply-To: <1186582307.3394.3.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708081628.36897.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 16:11, Paul Fulghum wrote:
> On Wed, 2007-08-08 at 14:45 +0100, Alan Cox wrote:
> > > I'm not familiar enough with the tty code to decide what the proper fix
> > > should be. I'll try to write a patch if someone could point me in the
> > > right direction.
> >
> > Something like this perhaps ?
>
> That looks good, a little better than the solution
> I was first considering. I'm compiling now.

The patch fixes the problem (at least under the test conditions that lead me 
to discover it in the first place). Thanks Alan.

> This was a nasty bug for me to introduce :-(
> Good work in finding this Laurent.

Thanks. It was a lot of work troubleshooting the problem. The bug report I got 
was along the lines of "after the 256th incoming modem call, the application 
doesn't receive data payloads anymore, but AT commands are still answered". I 
guess the challenge is what made it fun.

-- 
Laurent Pinchart
CSE Semaphore Belgium

Chaussée de Bruxelles, 732A
B-1410 Waterloo
Belgium

T +32 (2) 387 42 59
F +32 (2) 387 42 75
