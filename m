Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbYE1Omr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbYE1Omr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE1Omk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:42:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42915 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYE1Omj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:42:39 -0400
Date: Wed, 28 May 2008 15:42:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Qinghuang Feng <s3c24xx@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]scsi: check the return value of device_create_file() in powertec.c
Message-ID: <20080528144229.GG15470@flint.arm.linux.org.uk>
References: <200805252118.25798.s3c24xx@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805252118.25798.s3c24xx@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 09:18:25PM +0800, Qinghuang Feng wrote:
> This patch adds code to check the return value of device_create_file() called from powertecscsi_probe() in powertec.c 

I'd prefer not to kill the driver if device_create_file fails.  Just
arrange to print a warning instead (and remember not to unregister
the file if it wasn't created.)
