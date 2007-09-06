Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbXIFMsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbXIFMsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbXIFMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:48:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33464 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXIFMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:48:24 -0400
Date: Thu, 6 Sep 2007 14:48:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Guilherme Vilela <vilela.list@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problem to recognize that the file system is full
In-Reply-To: <89a10cbc0709040953i58f64a9cx957d69dd35519083@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709061445290.25942@fbirervta.pbzchgretzou.qr>
References: <89a10cbc0709040951u1786e7e3g76708bfcb7117f44@mail.gmail.com>
 <89a10cbc0709040953i58f64a9cx957d69dd35519083@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 4 2007 13:53, Guilherme Vilela wrote:
>Hi,
>I'm tryng to mount a nfs file system with the option async and run a
>program that writes to the file system. The problem is that the
>program keep writing even when the file system is full.

man 5 exports

   async  This option allows the NFS server to violate  the  NFS  protocol
          and  reply  to  requests before any changes made by that request
          have been committed to stable storage (e.g. disc drive).

>It appears
>that the nfs dont see that the file system is full and keeps writing
>to the cache. This program does'nt occur when mounting with the sync
>option or with async and noac option, but the performance get very
>poor and that is important to my application. The problem doesnt occur
>too with the local file system. I'm running linux centos 5.0.

About ac/localhost, I am not really sure what makes it work.

