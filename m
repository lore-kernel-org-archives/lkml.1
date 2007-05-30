Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXE3QGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXE3QGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXE3QGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:06:23 -0400
Received: from gw.goop.org ([64.81.55.164]:52238 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349AbXE3QGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:06:22 -0400
Message-ID: <465DA103.6090100@goop.org>
Date: Wed, 30 May 2007 09:06:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/7] cxgb3 - fix netpoll hanlder
References: <20070526225952.12115.30971.stgit@localhost.localdomain> <465B591B.1010507@garzik.org> <465CBE4B.9070009@goop.org> <465CC870.7050407@garzik.org>
In-Reply-To: <465CC870.7050407@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Look at the function argument... 

Yes, it's void *.  But my point is that C requires the ?: to evaluate to
some specific type, so if you have different types on each side of the :
the compiler can be legitimately upset.  The fact that the whole thing
gets cast to void * is somewhat irrelevant.

    J
