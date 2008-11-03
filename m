Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYKCNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYKCNcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYKCNcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:32:04 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:59513 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYKCNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:32:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=T3kNYhzLl/eClzTS1Imm2wser/83ru4Qj5HbvtHu0A08D+wbbh8LoBHfJ74yWn8fhJ
         kY0Bx1ILRJNArV/8JjEIpLDSXjSPE1StjkV0yKb5Nu4B8o444Abqncc2IpEJGIbehPo2
         GlKfz6tE5LP3b9qV2vuzqqHCTuXVwGsjz7noQ=
Message-ID: <8d6898730811030532nf4db16fv99b7b8cc722bda0b@mail.gmail.com>
Date: Mon, 3 Nov 2008 19:02:00 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sharing interrupt between PCI device
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think this question is already asked in this mailing list and Sorry
for asking this again.

My problem is this:

I have two PCI devices ( also two kernel drivers for those) which
shares the interupt. When I remove one driver other device stops
working, which is happening due to pci_disable_device () in removed
driver. This call is disabling the shared interrupt.

We can avoid this by just removing the pci_disable_device () in the
driver, but i dont think this is a good way (correct me if I am
wrong).

Can you suggest some ways to overcome this issue.

Thanks
Nobin Mathew.
