Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYJPTZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYJPTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYJPTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:25:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYJPTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:25:17 -0400
Date: Thu, 16 Oct 2008 12:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add support for Dallas DS28CM00 Unique ID chip
Message-Id: <20081016122502.3ad6e958.akpm@linux-foundation.org>
In-Reply-To: <48EB5FA7.4080701@mimc.co.uk>
References: <48EB5FA7.4080701@mimc.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008 14:09:59 +0100
Mark Jackson <mpfj@mimc.co.uk> wrote:

> This patch adds support for the (I2C based) DS28CM00 ID chip.

Please run scritps/checkpatch.pl across the diff and consider the
various things which it reports.  Many of them are minor layout issues.
The lack of printk facility levels is a should-fix thing.


>        printk("adding ds28cm00 driver !!\n");

Remove the " !!" :)

Please also cc i2c@lm-sensors.org on version 2.

Thanks.
