Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYCLKuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYCLKuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYCLKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:50:04 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:59589 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbYCLKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:50:03 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 06:50:03 EDT
Message-ID: <47D7B428.6010804@davidnewall.com>
Date: Wed, 12 Mar 2008 21:14:56 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Very probably this is due to broken way how X themselves implement 
> auto-repeat, instead of using kernel-provided auto-repeat functionality.

It should be said that X implements auto-repeat out of necessity.  While
the kernel can report key down and up events, its further interpretation
of those events is not appropriate.  Many combinations of events are
possible, such as keyboard plus mouse, and this precludes the kernel
from providing a full interpretation.  It would be wrong for it to even
try.  X is the proper place to implement auto-repeat for X.
