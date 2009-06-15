Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZFOKMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZFOKMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZFOKMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:12:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42023
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZFOKMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:12:34 -0400
Date: Mon, 15 Jun 2009 03:12:37 -0700 (PDT)
Message-Id: <20090615.031237.16489152.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.31-rc1: memory initialization warnings on sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670906150303o353f598dg4eb7b1f181344d8e@mail.gmail.com>
References: <a4423d670906150303o353f598dg4eb7b1f181344d8e@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know about them, I saw these messages too.

kmalloc() initialization got moved earlier so large swaths of sparc
early initialization need to move from bootmem to kmalloc or similar.

It's just a harmless warning as the bootmem code calls kmalloc()
if that's available already.
