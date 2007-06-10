Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbXFJWdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbXFJWdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbXFJWd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:33:28 -0400
Received: from rtr.ca ([64.26.128.89]:2505 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760062AbXFJWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:33:27 -0400
Message-ID: <466C7C35.7020105@rtr.ca>
Date: Sun, 10 Jun 2007 18:33:25 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc regression: smartctl does not work with SATA disk
References: <Pine.LNX.4.64.0706101049130.6348@kai.makisara.local>
In-Reply-To: <Pine.LNX.4.64.0706101049130.6348@kai.makisara.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara wrote:
> The command 'smartctl -a /dev/sdb' fails with 2.6.22-rc4 kernel. The 
> disk /dev/sdb is a SATA disk. The command does work still with a real SCSI 
> disk.

Last time I checked, one must supply the "-d ata" parameter to smartctl
for it to work with libata drives.  Has this changed?
