Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYLVUmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYLVUmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYLVUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:41:55 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:21594 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbYLVUly convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:41:54 -0500
From: Frans Pop <elendil@planet.nl>
To: "=?iso-8859-1?q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while interrupt hanging
Date: Mon, 22 Dec 2008 21:41:51 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl> <c62985530812220104s227f4d24k9142b56bce41f4f1@mail.gmail.com>
In-Reply-To: <c62985530812220104s227f4d24k9142b56bce41f4f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812222141.51834.elendil@planet.nl>
X-OriginalArrivalTime: 22 Dec 2008 20:41:52.0260 (UTC) FILETIME=[B84A5440:01C96475]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2008, Frédéric Weisbecker wrote:
> > Shouldn't force_clock_reprogram be reset to 0 after it has fired and
> > been handled?
>
> No, we need to keep the clock reprogramming forcing for each next
> hrtimer interrupt if we want the min delta to be used inside
> tick_dev_program_event(). 

Wouldn't that be worth a comment in the code?

Thanks a lot for the answers.
