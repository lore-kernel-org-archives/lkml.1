Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbYGZNbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbYGZNbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYGZNbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:31:17 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1710 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYGZNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:31:16 -0400
Message-ID: <488B271F.5090907@xs4all.nl>
Date: Sat, 26 Jul 2008 15:31:11 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: TD structure error TDindex=e
References: <48835302.1090708@xs4all.nl> <20080720160812.GA23652@electric-eye.fr.zoreil.com> <48836EB3.3050707@xs4all.nl> <20080720171440.GB23278@electric-eye.fr.zoreil.com>
In-Reply-To: <20080720171440.GB23278@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Can you apply the bandaid below too ?

Today, during a http transfer of a 5.xGB file the EN12000 system hang.
There was nothing in /var/log/messages.

So even with this patch something still goes wrong during
high-speed/large transfers, be it perhaps less often (as it appears)
since using the patch.

Udo
