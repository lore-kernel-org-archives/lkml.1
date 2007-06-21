Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXFUVlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXFUVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXFUVkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:40:55 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:41626 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbXFUVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:40:53 -0400
From: Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Date: Thu, 21 Jun 2007 23:40:52 +0200
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org, arw@arw.name
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Message-ID: <20070621214052.GB24218@faui01.informatik.uni-erlangen.de>
References: <11824417551424-git-send-email-arw@arw.name> <1182446251.2704.0.camel@laptopd505.fenrus.org> <20070621172557.GE9741@cip.informatik.uni-erlangen.de> <1182446983.2704.4.camel@laptopd505.fenrus.org> <20070621174612.GG9741@cip.informatik.uni-erlangen.de> <1182451789.2704.9.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182451789.2704.9.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > If a process uses read() it needs some executable and writable memory. We do
> > check for this in mprotect(). There is a problem with the i386-architecture,
> > because it allows execution of any readable page (except with newer
> > processors). But beyond that ugliness of i386, it should not be possible to
> > execute anything without us noticing it (hopefully).
> 
> welcome to mprotect() where the app can just change the permissions

We have mprotect covered. If a process tries to mprotect() some pages
executable, he had writable before, it is no longer trusted in our current
implementation.

We are beginning to feel like poeple do not look at our patches, because we
screwed up the msg-id, so our Patches are not visible as one clean thread. Sorry
for that.

regards,
	Johannes 

-- 
Johannes Schlumberger                      Department of Computer Science IV
Martensstrasse 1  D-91058 Erlangen Germany  University of Erlangen-Nuremberg
             http://wwwcip.informatik.uni-erlangen.de/~spjsschl
