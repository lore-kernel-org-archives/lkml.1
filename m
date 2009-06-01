Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZFANlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZFANlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZFANlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:41:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:49075 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbZFANlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LGHz+bqWLAIjyhDU/kF7TQsLl6xiyDqNxl8jnjuTUADysEYpCfYfyIIHE7aoDQqP4y
         sqV/lvrQo+xVLurLdWrqau/p4WPezPRAj9kkNLKyt3Y6uz/Jg110QfIS3SxvXDJoDB3J
         UhoFJIa9Tc3j461iMc0NwXZQqCPU9L6eTop6I=
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 09:41:07 -0400
Message-ID: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com>
Subject: Linux scheduler capabilities for batch jobs.
From: J Louis <handstogether8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have been writing user land server code and increasingly I find
myself writing resource management code which I think would be better
handled by the scheduler.  The problem can be described as "don't run
this process if the machine is swapping."  I would think that this
would be a common enough need that it was already in the kernel.  I'm
hoping it is and I have simply overlooked it (part of the reason for
this post,) but I've looked around a good bit and most of the
scheduler enhancements have to do with real time and latency, not
batch jobs.

My problem is analogous to a parallel make.  Say I have an 8 CPU
machine, and I run "make -j8".  If the total memory of the 8 jobs
throws the machine into swap, it begins to thrash and runtime is
awful.  I believe this is aggravated by the scheduler trying to be
fair, and keeping all 8 processes running.  If it was possible to tell
the scheduler that it was OK not to be fair when scheduling these
processes, I think the total runtime could be reduced if it put some
of the processes to sleep while others completed.  Is there a way to
tell the scheduler it is allowed to do this?  Should there be?

Thank You,

Hands
