Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZEYQqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZEYQqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZEYQp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:45:58 -0400
Received: from smtpout7.uol.com.br ([200.221.4.198]:52372 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbZEYQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:45:58 -0400
Date: Mon, 25 May 2009 13:45:54 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@users.sf.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Question on the removable flag of USB devices
Message-ID: <20090525164553.GA5572@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: f892aa41d5c22a3d3979f19c3252cf40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,

Since we're talking about USB devices, I would like to ask you one
thing: I have some USB HD enclosures and I want to mount them with
pmount, for instance.

Unfortunately, pmount won't allow the user to mount devices if it has
the removable flag set to 0.

For instance, here is one of my external drives:

rbrito@chagas:~$ cat /sys/block/sda/removable 
0
rbrito@chagas:~$ 

The question is: how are devices determined to be removable or not?
Sorry if this question is too naive.


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
