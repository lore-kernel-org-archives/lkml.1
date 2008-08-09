Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbYHIIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbYHIIwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYHIIwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 04:52:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:18004 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYHIIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 04:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:organization:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=dObLH2LuldPfqEMxoHnUYOyGryu1JZdy7GD9yP6PjJ6b8DlSvzzWMYVg797oDwiAfu
         s/v4fjr2xgZjRkAnLlrDufwj2X0rzweKcr+FVnyqhjwSsnj2KoH2aPf+p39oaeQA1CW3
         CmdY+sH6erxKUMPdfKs2jQZmy4skfhoBZ4UyQ=
Date: Sat, 9 Aug 2008 11:52:00 +0300
From: post-factum <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: scaling doesn't work after waking up
Message-ID: <20080809115200.6d2ee6dc@gmail.com>
Organization: StreamOS Developing Community
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After suspending to RAM scaling doesn't work for the second core of my
Pentium Dual-Core T2330.

Before suspending:
cpu MHz         : 800.000	#CPU0
cpu MHz         : 800.000	#CPU1

After suspending and waking up:
cpu MHz         : 800.000	#CPU0
cpu MHz         : 1596.079	#CPU1

I've observed it with kernel 2.6.25 and current 2.6.26.

Processor ID:
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Pentium(R) Dual  CPU  T2330  @ 1.60GHz
stepping        : 13

Regards,
  post-factum
