Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZDIKcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZDIKcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbZDIKba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:31:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43615 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912AbZDIKb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:31:29 -0400
To: Imre Gergely <gimre@narancs.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Finding lost memory + kernel messages explained
From: Andi Kleen <andi@firstfloor.org>
References: <49DDB609.8050405@narancs.net>
Date: Thu, 09 Apr 2009 12:31:27 +0200
In-Reply-To: <49DDB609.8050405@narancs.net> (Imre Gergely's message of "Thu, 09 Apr 2009 11:47:05 +0300")
Message-ID: <87y6ua86f4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imre Gergely <gimre@narancs.net> writes:
>
> That would be around 3896MB. My question is: where does the memory go?
> Is it normal to 'lose' that much (~130MB) ?

I wrote a paper about this topic some time ago.

http://halobates.de/memory.pdf
http://halobates.de/memorywaste.pdf

> One thing I tried was appending iommu=off at boot, which gave me back

That means if you have any devices that cannot addresses > 32bit they
will panic with that setting.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
