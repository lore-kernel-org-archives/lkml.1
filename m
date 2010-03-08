Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0CHQBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:01:05 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:55050 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0CHQBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:01:00 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: David Newall <davidn@davidnewall.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 8 Mar 2010 17:00:57 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-self-05680-gb8fa057-dirty; KDE/4.3.4; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>
In-Reply-To: <4B9518DA.8010201@davidnewall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003081700.57245.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 08 März 2010 16:33:46 schrieb David Newall:
> Christian Borntraeger wrote:
> > Some bigger things are missing in the e4defrag tool:
> > ...
> > - overall layout considerations (e.g. putting files close to its directory or
> >   use the atime to move often used files to the beginning of a disk etc.)
> 
> Shouldn't oft-used files be placed closer to the middle?  If you place 
> them at the beginning of the file, it's only possible for the head-stack 
> to be close to the file from the inner direction.  Place them in the 
> middle and it's possible for the head-stack to be close from the outer 
> direction, too, which sounds like a doubling of probability.  It seems 
> that it's the least frequently used files that should be placed at one 
> end of the disk or the other.
> 

Maybe. This was just an example of things that you can come
up with and which are not yet possible up in e4defrag. 

Christian
