Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYCQGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYCQGnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYCQGmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:11 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:30005 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYCQGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=X7m3jI5f2sqckAopV1W3gJ+0XdRyKeyqicsKC+4+TgVVmvRkOamU55pUn3BtL2ylIgjGorx/FRntay61x6YR3pM2gM4vq3LHyRBuzw0TtFGKKMJcP5b8V+RB5ILbUHdBGPhrRnfROAz2O8x8zHCA6TKPTUoFyKDJZMThrB518vk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/17] ide-tape: remove pipeline functionality-v3
Date: Mon, 17 Mar 2008 07:41:13 +0100
Message-Id: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's the rest of the pipeline removal series. What's left is to rewrite the
whole allocation logic around tape->merge_stage and all the other small buffers
so that we can get at least some sanity into the driver before working on it
any further :).

 Documentation/ide/ide-tape.txt |  211 ++++---------
 drivers/ide/ide-tape.c         |  689 ++--------------------------------------
 2 files changed, 99 insertions(+), 801 deletions(-)
