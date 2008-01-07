Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYAGUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYAGUXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYAGUXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:23:23 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:34434
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYAGUXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:23:23 -0500
Mime-Version: 1.0 (Apple Message framework v753)
In-Reply-To: <F59D6EFA-C8EC-4678-97CE-8726260606EE@neuf.fr>
References: <F59D6EFA-C8EC-4678-97CE-8726260606EE@neuf.fr>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B4617BF6-ABC5-4B38-801C-142ED3882444@neuf.fr>
Content-Transfer-Encoding: 7bit
From: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <guillaume-laures@neuf.fr>
Subject: Re: PROBLEM: I/O scheduler problem with an 8 SATA disks raid 5 under heavy load  ?
Date: Mon, 7 Jan 2008 21:22:57 +0100
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I should have tried to answer my own question earlier... but  
there is still a problem.

A quick reading of Wikipedia later, I can tell the following.
First, the anticipatory scheduler seems to be the worse choice when  
dealing with raid arrays.
Now, a better choice in my case could be:
- the CFQ scheduler for the array in the dom0;
- and the NOOP scheduler for the VBDs in the domUs (seems already  
there by default btw)

However even with CFQ/NOOP I keep getting soft resets, only the  
sata_nv SATA ports, when under load. Any thoughs ?


Thanks to all who did not flame me on this one ...;-)

GoM 
