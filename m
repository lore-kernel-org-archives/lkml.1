Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYGRPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYGRPwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYGRPwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:52:11 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56145 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbYGRPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:52:10 -0400
Date: Fri, 18 Jul 2008 17:52:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, robert.moore@intel.com
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
Message-ID: <20080718155206.GD32051@basil.nowhere.org>
References: <s5hzlof1ll2.wl%tiwai@suse.de> <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de> <s5hr69rz57u.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr69rz57u.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Jul 2008 15:52:03.0951 (UTC) FILETIME=[39322FF0:01C8E8EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll investigate a bit.  Any hints are appreciated.

Don't know what causes it then.  Could you please bisect?

To cut it short you might want to start with the ACPI merge
only (d442cc44c0db56e84ef6aa244a88427d2efe06cd) and first check if that 
kernel didn't do it and the patch after it did 
(4314652bb41df08ad65bd25176ba1dfd24b14a51) 

Then you can bisect between the two relatively quickly.

Thanks,

-Andi
