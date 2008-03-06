Return-Path: <linux-kernel-owner+w=401wt.eu-S934754AbYCFRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbYCFRCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763317AbYCFRCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:02:24 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34205
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbYCFRCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:02:24 -0500
Message-Id: <47D031CD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 06 Mar 2008 17:02:53 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: mach_reboot_fixups()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

was it intentional to remove the call to mach_reboot_fixups() during
the merge of reboot_{32,64}.c? If so, it seems odd that
reboot_fixups_32.c was left in the tree (and there was even stuff
added to it). But it would rather seem that those machines dealt with
in that file would not reboot properly anymore (for one of my boxes
I added an entry in that table to make it boot properly, which is why
I noticed the code not being called anymore)...

Thanks, Jan

