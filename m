Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYAYQtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYAYQtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYAYQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:49:37 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33879 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbYAYQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:49:36 -0500
Subject: Re: INITIO scsi driver fails to work properly
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
References: <1200070903.3286.28.camel@localhost.localdomain>
	 <9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	 <1200410166.9273.4.camel@localhost.localdomain>
	 <20080116145916A.fujita.tomonori@lab.ntt.co.jp>
	 <1200495471.3136.1.camel@localhost.localdomain>
	 <20080121222037.3d8b46a1@lxorguk.ukuu.org.uk>
	 <9f00bd9d0801220950r49de29abl8fbb2495a65c9a10@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 10:49:32 -0600
Message-Id: <1201279772.3119.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 19:50 +0200, Filippos Papadopoulos wrote:
> I get the following:
> SAH
> SSH
> SCB Q
> SCB EXEC
> SCB EXEC DONE

Actually, I suspect your issues should be fixed by this patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e2d435ea4084022ab88efa74214accb45b1f9e92

Could you download 2.6.24 and try it out to see if they are?

Thanks,

James


