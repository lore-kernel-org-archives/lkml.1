Return-Path: <linux-kernel-owner+w=401wt.eu-S1767644AbXDFNq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767644AbXDFNq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767646AbXDFNqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:46:25 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:49720 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767644AbXDFNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:46:24 -0400
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Andrew Burgess <aab@cichlid.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <200704060221.l362LD4s025776@cichlid.com>
References: <200704060221.l362LD4s025776@cichlid.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 08:44:54 -0500
Message-Id: <1175867094.3677.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 19:21 -0700, Andrew Burgess wrote:
> 2.6.20.4 with your patch dies in the memcpy (as does 21-gitN)
> 
> 2.6.20.4 without your patch dies in the subsequent __free_page
> with a null pointer ref at 000...008
> 
> James should I try your posted patch? On which kernel?

Well, mine will work, but will also cover up the problem.  It looks like
the scatterlist is getting corrupted by the HBA driver somehow ... we
really need to root cause this, otherwise other things will go wrong in
strange ways.

Just to confirm, the HBA with the problem is 3w-xxxx?

James


