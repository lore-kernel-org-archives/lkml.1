Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYIDCjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYIDCjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYIDCjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:39:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49043 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbYIDCjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:39:14 -0400
X-Sasl-enc: RU+eOC0MPUc8lI6RSx93By4dWOgV0ztaIFWrmr+XtPuk 1220495952
Date: Wed, 3 Sep 2008 23:39:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Milan Broz <mbroz@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [patch 00/42] 2.6.26-stable review
Message-ID: <20080904023905.GA1071@khazad-dum.debian.net>
References: <20080903172447.GA7731@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903172447.GA7731@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about this one:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21

"ACPI: Fix thermal shutdowns" ?

It should have been submitted to stable@k.o well before 2.6.26.3, but it
wasn't for some stupid reason.  Then some of us noticed it was missing in
2.6.26.3, and gave everyone a head's up, but it was too late for 2.6.26.3.

And now it also apparently failed to make it to 2.6.26.4?

As far as I recall, without this patch, all X6* ThinkPads that are not in
absolute top-notch thermal condition heat up until they are forced to
shutdown due to overtemperature (thus, slowly further damaging hardware that
is not in good shape to begin with).

Greg, is there any way to include the above patch for 2.6.26.4?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
