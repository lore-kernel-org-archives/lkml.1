Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZKGXoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZKGXoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 18:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZKGXoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 18:44:12 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:44282 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZKGXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 18:44:12 -0500
Date: Sun, 8 Nov 2009 00:45:33 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, gregkh@suse.de,
       yuasa@linux-mips.org
Subject: Re: [PATCH] leds: add exit function to cobalt-raq led.
Message-ID: <20091107234532.GA29450@linux-mips.org>
References: <1257616235-7840-1-git-send-email-tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257616235-7840-1-git-send-email-tfransosi@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07, 2009 at 12:50:35PM -0500, Thiago Farina wrote:

This driver has no exit function because it cannot be built as a module.
I've not reviewed the driver in detail but at the very least the
LEDS_COBALT_RAQ Kconfig statement for the driver would need to be changed
to tristate before this patch makes any sense.

  Ralf
