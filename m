Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYKEHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYKEHrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYKEHrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:47:15 -0500
Received: from eazy.amigager.de ([213.239.192.238]:34123 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYKEHrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:47:14 -0500
Date: Wed, 5 Nov 2008 08:47:12 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081105074712.GA2816@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105073306.GA3132@x61>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:33:08 +0100, Tino Keitel wrote:
> Hi,
> 
> I tried 2.6.28-rc3 (git a75952b) on my ThinkPad X61s, and now the fan
> runs at full speed after resume from suspend:

I forgot to look into the kernel logs for more info. Well, I found this
line:

thinkpad_acpi: restoring fan level to 0x07

So I guess that according to

ACPI: thinkpad-acpi: attempt to preserve fan state on resume

the attempt failed. :-)

Regards,
Tino
