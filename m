Return-Path: <linux-kernel-owner+w=401wt.eu-S1765942AbYCGUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765942AbYCGUfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbYCGUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:34:54 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:52314 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722AbYCGUex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:34:53 -0500
Date: Fri, 07 Mar 2008 21:34:51 +0100
Message-Id: <187794188@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Laurent.Vivier@bull.net
Cc: breeves@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] Modify loop device to be able to manage partitions
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+8gaeeBmP2xZyosFs3298eDzkCR20GxAlkqKAkxtV8gTC7F
 KyHwJuA/qZ7zSnQt3WpMOIKhFRLFEZZA/IJCqsEn0sa3+rujKQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Of course, the same behavior can be done using kpartx on a loop device,
>but modifying loop avoids to stack several layers of block device (loop +
>device mapper), this is a very light modification (40% of modifications
>are to manage the new parameter).

iirc, patches like this have been submitted more than once.
i remember i have seen one floating around years ago.

aside from the fact that using partitions on loop devices is useful - if 
we had dm-loop (http://sources.redhat.com/lvm2/wiki/DMLoop) in mainline - 
would using kpartx with that also mean stacking 2 layers of block device ?

personally, i like the kpartx approach. afaik, it`s working good.

i also like dm-loop, because i think that mapping of files to blockdevices 
belongs into an appropriate subsystem like device-mapper.

maybe some of the dm folks know better or have some real arguments - so i`m 
adding bryn reeves here. (just noticed that dm-loop disappeared from -mm due 
to removal of some api change - so it`s a good chance to bring it back into 
discussion) ;)

regards
roland


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

