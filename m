Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZFQS2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZFQS2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFQS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:27:57 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65070 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZFQS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:27:56 -0400
MIME-Version: 1.0
X-Originating-IP: [67.185.235.14]
In-Reply-To: <200906171032.23285.marc.pignat@hevs.ch>
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>
	 <1245200079-6323-3-git-send-email-rob@emanuele.us>
	 <200906171032.23285.marc.pignat@hevs.ch>
Date: Wed, 17 Jun 2009 11:27:57 -0700
Message-ID: <9f53b4330906171127y2fc7cc88w7764de9a6562e2a9@mail.gmail.com>
Subject: Re: [PATCH 3/6] atmel-mci: Optional controller reset before every 
	command
From: Robert Emanuele <rob@emanuele.us>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, nicolas.ferre@atmel.com,
       haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

(This may be a resend, gmail and its fancy text hates me.)

There has been debate over whether always reseting the MCI controller
is the correct thing to do.  I think for some platforms it is required
but there is no consensus to what those platforms are.  I think the
config option is the best of both worlds as a user of this
kernel/driver can choose to enable this or not without having to
modify their source.  It may even be a decent idea to enable this
option if they are using certain chips that we know reseting improves
their behavior.

Thank you,
Rob
