Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYKFPc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYKFPc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYKFPcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:32:19 -0500
Received: from eazy.amigager.de ([213.239.192.238]:34239 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKFPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:32:18 -0500
Date: Thu, 6 Nov 2008 16:32:15 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106153215.GA23739@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61> <20081106141121.GB23278@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141121.GB23278@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 12:11:21 -0200, Henrique de Moraes Holschuh wrote:

[...]

> and must set it to the higher of (saved, current) using this rule:
> 
> fulll-speed > 7 > AUTO.

Maybe the level values should be changed to describe this order.
Currently, it's AUTO (0x80) > full-speed (0x40) > 7. There are already
29(!) functions just for the fan handling, so there should be enough
room for a bit of abstraction. :-) I think it could have the benefit of code
which is easier to read and maintain. Correct me if I'm wrong.

Regards,
Tino
