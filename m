Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZD2FpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZD2FpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZD2FpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:45:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbZD2FpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:45:05 -0400
Date: Tue, 28 Apr 2009 22:42:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 07/30] microblaze_mmu_v1: MMU initialization
Message-Id: <20090428224247.888c3076.akpm@linux-foundation.org>
In-Reply-To: <1240821139-7247-8-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
	<1240821139-7247-2-git-send-email-monstr@monstr.eu>
	<1240821139-7247-3-git-send-email-monstr@monstr.eu>
	<1240821139-7247-4-git-send-email-monstr@monstr.eu>
	<1240821139-7247-5-git-send-email-monstr@monstr.eu>
	<1240821139-7247-6-git-send-email-monstr@monstr.eu>
	<1240821139-7247-7-git-send-email-monstr@monstr.eu>
	<1240821139-7247-8-git-send-email-monstr@monstr.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 10:31:56 +0200 monstr@monstr.eu wrote:

> +	/* Check for nobats option (used in mapin_ram). */
> +	if (strstr(cmd_line, "nobats"))
> +		__map_without_bats = 1;

Sometime you could go through the architecture and document all of its
kernel command-line parameters in Documentation/kernel-parameters.txt.

Or maybe document them in a separate microblaze documentation file,
which gives you a bit more freedom to expound upon what they do.

