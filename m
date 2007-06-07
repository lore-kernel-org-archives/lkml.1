Return-Path: <linux-kernel-owner+w=401wt.eu-S965532AbXFGA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbXFGA06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbXFGA0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:26:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3563 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbXFGA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:26:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 Jun 2007 17:26:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: init_task & Co.
Message-ID: <Pine.LNX.4.64.0706061722390.10383@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sure there's a good reason behind, but why are those variables 
replicated in every architecture?
Those are global variables, defined in global include files, and AFAICS 
they could be moved in a single kernel/init_task.c file. No?



- Davide

