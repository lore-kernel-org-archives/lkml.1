Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZFIXd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZFIXd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 19:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZFIXdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 19:33:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35079 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752457AbZFIXdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 19:33:51 -0400
Date: Wed, 10 Jun 2009 00:34:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       eibach@gdsys.de
Subject: Re: [PATCH 1/1] Char: moxa, prevent opening unavailable ports
Message-ID: <20090610003429.2a473a76@lxorguk.ukuu.org.uk>
In-Reply-To: <20090609122735.9a915cbf.akpm@linux-foundation.org>
References: <1244557981-9443-1-git-send-email-jirislaby@gmail.com>
	<20090609122735.9a915cbf.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw, what's this code in moxa_open() doing?
> 
> 	if (port == MAX_PORTS) {
> 		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
> 	}
> 
> why does it return 0 if CAP_SYS_ADMIN?				

0-MAX_PORTS-1  = tty devices
MAX_PORTS = magic secret control channel

Alan
