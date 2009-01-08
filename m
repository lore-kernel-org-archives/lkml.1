Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbZAHTQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbZAHTQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbZAHTQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:16:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:19163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbZAHTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GDbpVjkGXViPv4bfQ9kXsgM8nZ+eGYs1ueSNKuaVnQxDq6bkCJsHHtn9gUh9BBUH5w
         gb8aOCWrcchr3hiUFtzcy4DVDbTtTwKuq9LoYGQ4SAkeeH8hurIewa4dwQsz04Jlf6tY
         QZDLuFzwrbGwIy8qtAsIysB7Rm2Dv3aFs370g=
Message-ID: <b6fcc0a0901081115n1174aebj5f6a3fbb8adea789@mail.gmail.com>
Date: Thu, 8 Jan 2009 22:15:56 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: arjan@infradead.org, torvalds@osdl.org
Subject: Too async libata breakage
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f29d3b23238e1955a8094e038c72546e99308e61 aka
"fastboot: Make libata initialization even more async"
results in no findable /dev/sda2 to mount / here.

Kernel correctly sees sda as 750GB drive and the rest too.

CONFIG_ATA_PIIX is in use, everything built-in, plain partitions,
no initrd, DM, MD etc.
