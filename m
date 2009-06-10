Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZFJMAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZFJMAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZFJMAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:00:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48598 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZFJL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:59:59 -0400
Subject: Re: [PATCHv2] MTD: Add UBI reboot notifier
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1244626509.5847.399.camel@localhost.localdomain>
References: <1244550775.5847.385.camel@localhost.localdomain>
	 <f5be75d5abc1acd236bedf36c55a860e@localhost>
	 <1244626509.5847.399.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Jun 2009 14:59:42 +0300
Message-Id: <1244635182.5847.402.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jun 2009 11:59:43.0243 (UTC) FILETIME=[F0F735B0:01C9E9C2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 12:35 +0300, Artem Bityutskiy wrote:
> On Tue, 2009-06-09 at 10:59 -0700, Kevin Cernekee wrote:
> > Terminate the UBI background thread prior to restarting the system.
> > 
> > Changes from v1:
> > 
> > Add ubi_sync() at the end, to make sure the underlying MTD device has
> > synchronized its buffers.
> > 
> > Clean up comments and formatting.
> > 
> > Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
> 
> I've pushed this patch to ubi-2.6.git/master. I've tested it
> even. And I amended comments a little. Please, check it:
> 
> http://git.infradead.org/ubi-2.6.git?a=commit;h=79c293b2629882a1db3a850ed6b84bd1d8a464a7
> 
> If you are fine with this, I'll put it to ubi-2.6.git/linux-next
> and merge it this merge window.

Ok, I've actually pushed this to ubi-2.6.git/linux-next, I just
assume you should not have issues with my tweaks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

