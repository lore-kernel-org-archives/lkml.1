Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbXKKW31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbXKKW31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbXKKW3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:29:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57114 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbXKKW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:29:18 -0500
Date: Sun, 11 Nov 2007 23:29:16 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>
Subject: Re: Bind mount bug?
In-Reply-To: <200711111106.53494.elendil@planet.nl>
Message-ID: <Pine.LNX.4.64.0711112326030.25431@fbirervta.pbzchgretzou.qr>
References: <200711111106.53494.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> I'm not sure whether this is a bug or expected behavior.
>> Suppose I create a "looped" bind mount situation as follows.
>>
>> # mkdir test
>> # touch test/foo
>> # mkdir bindtest
>> # touch bindtest/bar
>> # mkdir bindtest/test
>> # mount --bind test/ bindtest/test/
>> # ls bindtest/test/
>> foo
>> # mount --bind bindtest/ test/
>
>This mounts the bindtest/ tree on test/ _without_ copying the mount  
>points which are found on subtrees. This is necessary to avoid loops  
>in the filesystem (bind mounts are somewhat like hardlinks on  
>directories, just without the headaches).

What you seek is mount --rbind.
