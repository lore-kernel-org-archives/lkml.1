Return-Path: <linux-kernel-owner+w=401wt.eu-S1764148AbYHFCBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764148AbYHFCBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbYHFCBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:01:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53037 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYHFCBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:01:17 -0400
Date: Wed, 6 Aug 2008 04:01:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jmerkey@wolfmountaingroup.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26 2/25] mdb: Merkey's Kernel Debugger
Message-ID: <20080806020152.GA24801@one.firstfloor.org>
References: <51549.166.70.238.45.1217815820.squirrel@webmail.wolfmountaingroup.com> <878wvb6i2o.fsf@basil.nowhere.org> <44644.166.70.238.45.1217985860.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44644.166.70.238.45.1217985860.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 07:24:20PM -0600, jmerkey@wolfmountaingroup.com wrote:
> 
> I'll post some patches with these changes and submit it as a module.  I
> will of course need to patch the kernel to introduce the die notifiers
> where
> they are not and there's the issue of cross call NMI to stop other
> processors on SMP.
> 
> That's the real issues, Andi, is the xcall stuff for IPC to control all
> the processors.

NMIs have die notifiers too. That said a cleaner way would be to generalize
the synchronization code already in kdump and reuse that.

-Andi
