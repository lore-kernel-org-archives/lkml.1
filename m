Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZFZJFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZFZJFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZFZJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:04:54 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43776 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZFZJEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lvLSaMvxr9s6WJy90TWGCJCBCiZYic3AXl+gG1IdVZ8+6jXSENZOKbNVQ0CWFIIDaC
         vUCy7X4Vp9PIxF06oceIVTAOnFS3fMj8j1mj8sRMp+8M27SDcoT0L/mOEbePVC9RR/SN
         T+g2ZssiOlCD4J/ydO34O78rxwqYOeQUzdXU4=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 12:58:22 +0400
Message-ID: <a4423d670906260158q15080049ue516c3d454f4afbf@mail.gmail.com>
Subject: 2.6.31-rc1: parisc: multiple PCI BAR collisions
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Hardware is HP j6000.
It cannot initialize many PCI devices (sym53c8xx, tulip, STI,
usb(onci)) and cannot boot (no root device).
Messages like this:
sym53c8xx 0:0:0f.0: device not available because of BAR 1 [0xf4005000
- 0xf40053ff] collisions.
