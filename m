Return-Path: <linux-kernel-owner+w=401wt.eu-S1751669AbZITLba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbZITLba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZITLb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:31:28 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40189 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbZITLb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:31:26 -0400
X-Greylist: delayed 868 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 07:31:26 EDT
X-Sasl-enc: nr14sfHmYyCzx7PXxRdZv6JR+1O/+MJgN84Uw4Xx+6XS 1253445421
Date: Sun, 20 Sep 2009 08:16:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com,
       corentincj@iksaif.net
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
 generate events on changes
Message-ID: <20090920111656.GA6645@khazad-dum.debian.net>
References: <1247587564-27737-1-git-send-email-mjg@redhat.com>
 <20090919232424.GA15200@khazad-dum.debian.net>
 <20090920041554.GA9229@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920041554.GA9229@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Matthew Garrett wrote:
> On Sat, Sep 19, 2009 at 08:24:24PM -0300, Henrique de Moraes Holschuh wrote:
> > Should the driver notify of *any* changes, even when the user is hitting the
> > "ceiling" or the "floor" and the backlight value didn't really change?
> 
> I'd say yes - the user will expect the UI to appear whenever they hit 
> the button.

Ok.  The thinkpad-acpi changes depends on a large patchset that I should
send to Len today.  After that, I will send the patch that adds brightness
event support.

Are you backlight patches in any tree?  Are them expected to hit mainline
this merge window?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
