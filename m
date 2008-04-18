Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYDRXpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYDRXpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYDRXpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:45:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYDRXpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:45:03 -0400
Date: Fri, 18 Apr 2008 16:44:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-Id: <20080418164411.b1e1628d.akpm@linux-foundation.org>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 19:22:45 -0400 (EDT)
Jeff Garzik <jeff@garzik.org> wrote:

> Avoid confusion by /not/ passing an unused pointer to
> arm_rtc_interrupt()
> 
> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.

#irq-remove doesn't seem to be included in the #ALL branch which
I'm grabbing?
