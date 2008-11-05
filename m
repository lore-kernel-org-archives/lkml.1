Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYKEM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYKEM0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 07:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYKEM0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 07:26:36 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40842 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbYKEM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:26:36 -0500
X-Sasl-enc: mNYARLHYJyN4EW+ZLVx9QwyTtWlMEDzL8bx/vURtgfhp 1225887994
Date: Wed, 5 Nov 2008 10:26:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081105122632.GC14931@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105074712.GA2816@x61>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008, Tino Keitel wrote:
> On Wed, Nov 05, 2008 at 08:33:08 +0100, Tino Keitel wrote:
> > I tried 2.6.28-rc3 (git a75952b) on my ThinkPad X61s, and now the fan
> > runs at full speed after resume from suspend:
> 
> I forgot to look into the kernel logs for more info. Well, I found this
> line:
> 
> thinkpad_acpi: restoring fan level to 0x07
> 
> So I guess that according to
> 
> ACPI: thinkpad-acpi: attempt to preserve fan state on resume
> 
> the attempt failed. :-)

Indeed.  Please send the full kernel output of thinkpad-acpi, showing boot,
suspend and resume messages from the driver, please?

Also, please tell me what is the contents of /proc/acpi/ibm/fan (and if
possible, the contents of /proc/acpi/ibm/ecdump) before you issue the
suspend command.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
