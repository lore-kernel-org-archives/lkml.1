Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZFPOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZFPOte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZFPOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:49:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34291 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751533AbZFPOt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:49:27 -0400
Date: Tue, 16 Jun 2009 15:50:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Bradbury <robert.bradbury@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler fails to allow for "niceness" with new/fast processes
Message-ID: <20090616155034.0bb7decd@lxorguk.ukuu.org.uk>
In-Reply-To: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
References: <deaa866a0906160723k78c3c54bv35e2e2406e3d13d1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of patterns of activity where the bottleneck will be I/O
rather than CPU, and nice is basically about CPU priority. Package
building does tend to do a lot of disk writing so its not entirely
unexpected
