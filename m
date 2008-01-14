Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbYANVpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbYANVpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYANVoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:44:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2242 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYANVoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=SavnSSHTJ8vdVBbaGoftbQh0x7RQW/RnqQkeOe2FUwXX7sIj79aFy4S6s6FwFwJuXCyyAF/yJa5IG1a+JKLcLG5z8l/KIcQeb6h/fIdwia57cUvOAQCubcOMWFoRRS7olgSmCH3D5putccL1sO7fGWfaHzpD0z4E3fr2Y5zbESU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 11/12] ide-floppy: remove IDEFLOPPY_DEBUG_INFO
Date: Mon, 14 Jan 2008 22:51:36 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-12-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200255505-31418-12-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801142251.36534.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2008, Borislav Petkov wrote:

[...]

> -		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes long\n");
> +		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes "
> +				"long\n");

I added dumping 'gcw.packet_size' for unsupported packet sizes while
merging the patch.
