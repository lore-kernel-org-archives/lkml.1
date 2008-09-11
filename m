Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYIKFU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYIKFU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYIKFUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:20:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbYIKFUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:20:20 -0400
Date: Wed, 10 Sep 2008 22:19:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: mikhail.kshevetskiy@gmail.com, linux-kernel@vger.kernel.org,
       aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
Message-Id: <20080910221947.94409642.akpm@linux-foundation.org>
In-Reply-To: <48C89D9F.5080404@shaw.ca>
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no>
	<fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
	<48C863CC.3010902@shaw.ca>
	<20080910173630.d0d38697.akpm@linux-foundation.org>
	<48C89D9F.5080404@shaw.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 22:25:03 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Enabling by 
> default and disabling after a TX done interrupt was received would 
> likely be a better approach

yup, that's far better.

> But it's quite likely that at least some of the 
> chipsets that this driver supports don't need this timer nonsense at all

Well yes.  If all the chipsets need the timer then there's nothing we
can do to improve it.

