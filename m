Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYKFDd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYKFDd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKFDdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:33:20 -0500
Received: from main.gmane.org ([80.91.229.2]:58396 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYKFDdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:33:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Guyot-Sionnest <dermoth@aei.ca>
Subject: AACRAID: Adaptec 2120S/2200S with +4GB RAM broken since 2.6.24, still
 not fixed
Date: Wed, 05 Nov 2008 22:33:01 -0500
Message-ID: <getohg$j4u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl-61-62.aei.ca
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This has been discussed before; servers with Adaptec 2120S and 2200S
(and maybe others) are broken since 2.6.24 on systems with >4GB RAM. The
following commit (meant to make some PowerEdge controllers work) broke it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94cf6ba11b068b8a8f68a1e88bffb6827e92124b

It is not clear in the related bugtracker on which basis all those
controllers were given the AAC_QUIRK_SCSI_32 flag but it definitely
break at least two of them, possibly others. There's multiple reports of
it, threads in this and others mailing list, bug reports to various
distributions, but still no fix!

Tomas Henzl from Redhat posted a patch here nearly one moth ago (just
before 2.6.27) which didn't get picked up for 2.6.28:

http://lkml.org/lkml/2008/10/7/164

Other references:

http://bugzilla.kernel.org/show_bug.cgi?id=9133
https://bugzilla.redhat.com/show_bug.cgi?id=453472
https://bugzilla.redhat.com/show_bug.cgi?id=457552

Some more interesting links:
http://marc.info/?l=linux-kernel&m=122166454808377&w=2


You can also search this on Google for even more reports:
AAC_QUIRK_SCSI_32
"aac_fib_send failed with status 8195"

Thanks,

Thomas

