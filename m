Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXFMNR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXFMNR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXFMNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:17:19 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:46354 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXFMNRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:17:19 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Re: ext2 on flash memory
References: <20070611173611.GA2433@DervishD>
In-Reply-To: <20070611173611.GA2433@DervishD>
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2007 15:16:40 +0200
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200706131516.41142.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for this hand-crafted message. I'm not subscribed, lkml.org is down, so 
I have to manually add the Reply-To header.)

>     I was just wondering if, apart from the excessive wear, there were
> other reasons. One of the reasons I would like to use a good filesystem
> for a pendrive is to be able to store file metadata (UID, GID, mode,
> etc.) properly, for example to store a "live" copy of my home dir in the
> pendrive.
If it would be enough to have a backup (with meta-data), that needs some 
software to be read again, you could also try fsvs (http://fsvs.tigris.org).

That does a full filesystem versioning (with owner, group, mode and mtime) 
into a subversion repository. This would have the benefit that you could keep 
the "prefered" filesystem, but have a (versioned!) backup of your data.


The files can, if fsvs is not available, be restored by subversion binaries 
(although without meta-data support), so in case of an emergency you could 
read the data even from windows. (Like when using tar, you'd need to download 
something or keep this binary on the usb-stick).


http://freshmeat.net/projects/fsvs:
  FSVS stands for "Fast System VerSioning", "File System VerSioning", or "Full
  System VerSioning". It is used for backup/restore and system configuration
  management, using a Subversion repository as the backend.

For questions "users" or "dev" "at fsvs.tigris.org" are available.


Regards,

Phil
