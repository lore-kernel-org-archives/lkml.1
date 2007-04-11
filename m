Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXDKEj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXDKEj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161179AbXDKEj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:39:27 -0400
Received: from [212.12.190.198] ([212.12.190.198]:36022 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161172AbXDKEj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:39:26 -0400
From: Al Boldi <a1426z@gawab.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Date: Wed, 11 Apr 2007 07:42:38 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704110112.39425.a1426z@gawab.com> <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704110742.38727.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 11 2007 01:12, Al Boldi wrote:
> >Jan Engelhardt wrote:
> >> the following patch series turns some menus into menuconfigs, so they
> >> can be disabled whilst "walking" thorugh the parent menu
> >
> >Great, but instead of making it a simple on/off, make it tri-state that
> > would default select all child-options appropriately.  (see HW_RANDOM)
>
> I do not remember having touched the Random Number Generators or Character
> Devices anywhere in this series.
>
> Don't worry, I have paid attention (or at least I hope so ;-) to
> 'm'-able options, for example the SCSI, IEEE1394, or I2C stacks.
>
> But, for example you will see
>  [*] Old CD-ROM drivers (not SCSI, not IDE)
>
> which is because this entry in itself does not generate any object file.
>
> Generally, I just made the 'menuconfig' entry have the same state
> (bool/tristate) as the original entry. If I have overseen that
> somewhere, please let me know!

Correct, no oversight here; but it may be more meaningful, if you could 
default select child-options based on the parent-state, like HW_RANDOM.

Also, I don't think it's necessary to touch any of the "depends on"; keep 
them as is, as they don't hurt staying that way, and may actually be 
necessary under certain circumstances.  (see EMBEDDED)


Thanks!

--
Al

