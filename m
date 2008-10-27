Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYJ0VHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYJ0VHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJ0VHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:07:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18068 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ0VHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j1KQD3PEWgBy26TfcAv7aMHZi/wFCf8dBG5EKLGN6FlX/njImV+sWaHQuI/qL6+BUl
         M/vesXDrIPWsEJTrJQ1pooilBsCmRUSgHafzrRZOqwi/l1EPrht0QEqGcmQvabn62PZh
         5r2t9wuOJS+DIEgoTIn5Cxh7e/nBIiDJ7FHyU=
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, kernel@nn7.de
In-Reply-To: <200810272159.52947.borntraeger@de.ibm.com>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810272159.52947.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 14:06:56 -0700
Message-Id: <1225141616.5396.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 21:59 +0100, Christian Borntraeger wrote:
> Am Montag, 27. Oktober 2008 schrieb Carlos R. Mafra:
> > Hi,
> > 
> > So I managed to bisect my suspend to RAM regression in 2.6.27-rc2
> > to commit 3b7ee69d0caefbdb85a606a98bff841b8c63b97e ("mac80211: disassociate 
> > when moving to new BSS") by Tomas Winkler (Cc:-ed).
> 
> I was also bisecting a suspend to RAM regression in 2.6.28-rc1 but I had to 
> stop the bisect due to another problem in that bisection. I can confirm that 
> this patch was among the ~50 patches left to test.

This also looks like a regression I've been looking at, 
but suspend-to-disk, and b43 driver.  On resume, nothing but a blackscreen and
unresponsive.

I'll try reverting that one patch and see if it fixes it.

Harvey

