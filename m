Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZEQV4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZEQV4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZEQV40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:56:26 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:44158 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbZEQV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:56:25 -0400
Date: Sun, 17 May 2009 23:57:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: David Dillow <dave@thedillows.org>, linux-kernel@vger.kernel.org,
       Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
Message-ID: <20090517215724.GA7699@electric-eye.fr.zoreil.com>
References: <1242323133.32579.4.camel@lap75545.ornl.gov> <200905142322.n4ENMJP3028786@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <200905142322.n4ENMJP3028786@turbo.physics.adelaide.edu.au>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Jonathan Woithe <jwoithe@physics.adelaide.edu.au> :
[...]
> Indeed.  To follow up on this, as per my earlier email I left the machine
> disconnected from the mains all night - so it was truly "off" for about 9
> hours.  Just before coming to work I flicked it on and the "link" LED lit
> almost immediately.  So whatever the Realtek driver did, the resulting
> status would appear to be stored in some kind of non-volatile memory.  While
> it would appear that this has worked around the problem for me, it would be
> nice if the mainline driver could do this itself.

The attached patch is not complete but can you give it a try and check if
it makes a difference ?

Thanks in advance.

-- 
Ueimor

--fdj2RfSjLxBAspz7
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="r8169-8168d.patch.gz"
Content-Transfer-Encoding: base64

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

--fdj2RfSjLxBAspz7--
