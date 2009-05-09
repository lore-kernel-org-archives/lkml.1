Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZEIHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZEIHOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZEIHOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:14:10 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40099 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZEIHOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:14:09 -0400
Subject: Re: regression 2.6.30-rc4+git: oops in rfcomm_tty_open
 klist_add_tail
From: Marcel Holtmann <marcel@holtmann.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1241852186.14865.63.camel@localhost>
References: <1241852186.14865.63.camel@localhost>
Content-Type: text/plain
Date: Sat, 09 May 2009 00:13:47 -0700
Message-Id: <1241853227.4903.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

> I am seeing the oops below as soon as I try to bring up my internet
> connection over rfcomm via a bluetooth device. I think that things were
> working ok with 2.6.30-rc3 still but now I see this oops even after a
> clean reboot, reproducibly ...

please test with 2.6.30-rc5 since this one should be fixed. There is one
additional patch waiting in net-2.6 that fixes a memory allocation in a
context that can't sleep.

Regards

Marcel


