Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZCLN0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZCLN0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCLN0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:26:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZCLN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:26:45 -0400
Date: Thu, 12 Mar 2009 10:26:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>
Subject: feature-removal-schedule.txt for some I2C functions
Message-ID: <20090312102617.3235a35b@pedra.chehab.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On your entry at Documentation/feature-removal-schedule.txt:

What:   i2c_attach_client(), i2c_detach_client(), i2c_driver->detach_client()
When:   2.6.29 (ideally) or 2.6.30 (more likely)
Why:    Deprecated by the new (standard) device driver binding model. Use
        i2c_driver->probe() and ->remove() instead.
Who:    Jean Delvare <khali@linux-fr.org>

You forgot to add a check entry, like:
Check: i2c_attach_client i2c_detach_client i2c_driver->detach_client

The check entry is used by checkpatch.pl to warn about the usage of a legacy function.

Please fix it, since me and others rely on this tool to discover about the
usage of legacy functions.

Cheers,
Mauro
