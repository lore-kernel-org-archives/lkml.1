Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYHUONf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYHUONf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYHUONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:13:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:20587 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYHUONN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q2O/rtcGTNy7HWZm1+ZZasa7zcuGxjs1Z3PBmTsnPZRo1DmcS4kz9lDWWrqsa62Q1c
         fVlliZ3US16VYbMCuj+SRvmQOxGMojKT7sTw69qIzNBezd5arU+vs3Ujp4XAA2X10QK9
         zK3w7OD7wDbrjsBLSpNsZm7JcRCQj7mG5MXpw=
Message-ID: <6934efce0808210713m220d2a6cje06a2dc51c4a857a@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:13:12 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: carsteno@de.ibm.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com
In-Reply-To: <200808212043.51209.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <48AD42AE.4030107@de.ibm.com>
	 <200808212043.51209.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Agreed. I haven't had a good look through it yet, but at a glance it
> looks pretty neat. The VM side of things looks pretty reasonable
> (I fear XIP faulting might have another race or two, but that's a
> core mm issue rather than filesystem specific).

How might I design a test to flush those bugs out?  We haven't seen any.
