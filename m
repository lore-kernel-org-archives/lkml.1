Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbXIYT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbXIYT3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXIYT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:29:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:49460 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbXIYT3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VrgPH091NMOeHG0UkCPrlzxxz29pkkYwoBt+rXSfJVSVUhTf1od1ajg2Oa5wS1JpBoHXqBxbD25uWPi0PgZrhQKKeeKeGXPK1Qp3DjYiCtmk3iVDlQXDuCvUPAHhNtoiMCXd76rPhi9kK6clznR0M07YkFnwbrcLCqFmG6kMEKs=
Message-ID: <46F9617F.1010508@gmail.com>
Date: Tue, 25 Sep 2007 13:29:03 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org>
In-Reply-To: <46F8665A.4000206@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Once the blame has been squared fixed upon me :) you can use git-bisect
> to locate the precise change that broke your setup.

Okay, here's the problem:

268fe6f9f15551be9abedd44a237392675d529d5 is first bad commit
commit 268fe6f9f15551be9abedd44a237392675d529d5
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Sep 21 07:09:36 2007 -0400

    [libata] SCSI: simple TEST UNIT READY simulation

    It's trivial to ping the device, and that's a much more sane behavior
    than no-op.

    Signed-off-by: Jeff Garzik <jeff@garzik.org>

:040000 040000 44d34cdad073bd623545b8239aca9a113652c6d0
df6d21f7ce56a4e796f8f856c1f647b0395ab4df M      drivers

Berck
