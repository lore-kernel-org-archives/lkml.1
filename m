Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0CHPd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:33:58 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33741 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0CHPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:33:55 -0500
Message-ID: <4B9518DA.8010201@davidnewall.com>
Date: Tue, 09 Mar 2010 02:03:46 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com>
In-Reply-To: <201003080853.42978.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Some bigger things are missing in the e4defrag tool:
> ...
> - overall layout considerations (e.g. putting files close to its directory or
>   use the atime to move often used files to the beginning of a disk etc.)

Shouldn't oft-used files be placed closer to the middle?  If you place 
them at the beginning of the file, it's only possible for the head-stack 
to be close to the file from the inner direction.  Place them in the 
middle and it's possible for the head-stack to be close from the outer 
direction, too, which sounds like a doubling of probability.  It seems 
that it's the least frequently used files that should be placed at one 
end of the disk or the other.
