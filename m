Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXJKRvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXJKRvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbXJKRvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:51:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:13883 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXJKRvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KSh5QMeyrw0sN70VFnBd637PBw7//zcyWMgn5MEJrQGGeRqvHWgJeEew0RBPnkVAgB3GewCn4vOH/HrysXGs7FWJEzyBUIyDiGL5Y84KfZ2IRkrTiLCdkD3blyZsCZC9sWhMxIeVdgviybyKeCBB+/IlUiV8tWN65imXnN7Eejw=
Message-ID: <64bb37e0710111051w40409d61w91a4ec155abab41a@mail.gmail.com>
Date: Thu, 11 Oct 2007 19:51:11 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <470DC213.5080307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
	 <20071004170536.GY19691@waste.org>
	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
	 <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>
	 <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>
	 <470D97BD.4020300@gmail.com>
	 <64bb37e0710102254n60e22338t4baf75a47b93ac14@mail.gmail.com>
	 <470DC213.5080307@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Torsten Kaiser wrote:
> >>> That missing +1 would explain, why the SGE_TRM never gets set.
> >> Thanks a lot for tracking this down.  Does changing the above code fix
> >> your problem?
> >
> > I did not try it.
> > I'm not an libata expert and while this change looks suspicios, I
> > can't be 100% sure if that change was intended.
> > And I did not want to experiment this deep in the code and risk
> > corrupting the hole drive.
>
> I don't think you would risk too much by changing that bit of code.
> Please try it.

The debug output now shows that SGE_TRM is getting set.
I will try to reproduce the error tomorrow morning, and report if I'm
still seeing it.

Reporting that I'm no longer see it is sadly not a good indicator, as
it also seems to depend on other factors like memory layout and/or
code alignment.

Torsten
