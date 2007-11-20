Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbXKTUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbXKTUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760153AbXKTUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:25:21 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:60968 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760184AbXKTUZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:25:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18243.17058.469444.94821@stoffel.org>
Date: Tue, 20 Nov 2007 15:25:06 -0500
From: "John Stoffel" <john@stoffel.org>
To: "Abhishek Rai" <abhishekrai@google.com>
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
In-Reply-To: <d9885f0f0711180752o71561745h51f2a18d09709e27@mail.gmail.com>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	<20071115230219.1fe9338c.akpm@linux-foundation.org>
	<20071116073716.GB17536@waste.org>
	<d9885f0f0711180752o71561745h51f2a18d09709e27@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Abhishek> It took me some time to get compilebench working due to the
Abhishek> known issue with drop_caches due to circular lock dependency
Abhishek> between j_list_lock and inode_lock (compilebench triggers
Abhishek> drop_caches quite frequently). Here are the results for
Abhishek> compilebench run with options "-i 30 -r 30". I repeated the
Abhishek> test 5 times on each of vanilla and mc configurations.

Abhishek> Setup: 4 cpu, 8GB RAM, 400GB disk.

How about running these tests on a more pedestrian system which people
will actually have?  Like 1gb, 1cpu and 400gb of a single disk?  

