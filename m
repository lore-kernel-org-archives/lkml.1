Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXIUTSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXIUTSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbXIUTSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:18:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbXIUTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Hn2j4WZQynTZ14R8KhEy/liz7+2ipNQ4u94OB1gUCd4DmNNdSX/Xy6zXYzdH8rZ+3O84v8OUQ2+ZpWJ0RKTBEj+HeIKX/h5/5Su9OOgHczjytRDBsvNqA3bLB/lv05dT2mGzi5oonH3avrWz7/U1cGvJiPzs9c7y4h5Uf2O88M0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Fri, 21 Sep 2007 20:18:06 +0100
User-Agent: KMail/1.9.1
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com> <200709211905.23946.vda.linux@googlemail.com> <15775.1190399812@turing-police.cc.vt.edu>
In-Reply-To: <15775.1190399812@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212018.06553.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 19:36, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 21 Sep 2007 19:05:23 BST, Denys Vlasenko said:
> 
> > I plan to use gzip compression on following drivers' firmware,
> > if patches will be accepted:
> > 
> >    text    data     bss     dec     hex filename
> >   17653  109968     240  127861   1f375 drivers/net/acenic.o
> >    6628  120448       4  127080   1f068 drivers/net/dgrs.o
> >          ^^^^^^
> 
> Should this be redone to use the existing firmware loading framework to
> load the firmware instead?

Not in every case.

For example, bnx2 maintainer says that driver and
firmware are closely tied for his driver. IOW: you upgrade kernel
and your NIC is not working anymore.

Another argument is to make kernel be able to bring up NICs
without needing firmware images in initramfs/initrd/hard drive.
--
vda
