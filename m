Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbXFWSDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbXFWSDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXFWSDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:03:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2007 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbXFWSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:03:01 -0400
Date: Sat, 23 Jun 2007 20:03:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
cc: Akinobu Mita <akinobu.mita@gmail.com>, Alexander Wuerstlein <arw@arw.name>,
       linux-kernel@vger.kernel.org,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: Re: [PATCH] sns: add syscall to check signed state of a process
 [4/4]
In-Reply-To: <20070621164912.GD9741@cip.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.64.0706232002110.11964@fbirervta.pbzchgretzou.qr>
References: <11824417553291-git-send-email-arw@arw.name>
 <961aa3350706210934m11e7f0cq96f384056878cb43@mail.gmail.com>
 <20070621164912.GD9741@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 21 2007 18:49, Alexander Wuerstlein wrote:
>
>You seem to be right, the rest of the kernel just does 'if (!t)'. We just used
>IS_ERR() as the 'check for evil pointers' function.

But NULL is not covered by IS_ERR.


	Jan
-- 
