Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZGZVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZGZVh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 17:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZGZVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 17:37:25 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50612 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZGZVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 17:37:25 -0400
Subject: Re: [Patch RFC 15/37] bluetooth: Convert hdev->req_lock to mutex
From: Marcel Holtmann <marcel@holtmann.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090726081555.202765397@linutronix.de>
References: <20090726081459.455111897@linutronix.de>
	 <20090726081555.202765397@linutronix.de>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 23:36:24 +0200
Message-Id: <1248644184.28545.168.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> hdev->req_lock is used as mutex so make it a mutex.

no idea why we never changed this before.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marcel Holtmann <marcel@holtmann.org>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

In case this one is going via someone else's tree. Do you have any
preference how this gets merged. I can also take it via my tree.

Regards

Marcel


