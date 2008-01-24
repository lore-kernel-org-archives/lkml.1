Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYAXVm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYAXVm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbYAXVmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:42:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:49126 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286AbYAXVml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=BJsnU667tQkcdPkHYZX4KZHoJS1gfIKnPib+TF9Lac4cJhl44ITy4jGYV0dlxQ0xzUyXQHhZ41hEb+vFDdDj74LHiYjBRrzHiuEHaOC61b4aLOG97maDlEI5CkLdkBjsqDV8y4EadAVp3VeWkgupOxskNXJS39A06K/NcAswQ5c=
Date: Thu, 24 Jan 2008 22:42:39 +0100
To: linux-pcmcia@lists.infradead.org
Cc: linux@dominikbrodowski.net, linux-main <linux-kernel@vger.kernel.org>
Subject: [HD64461] Pcmcia driver and Vcc/Vpp issues
Message-Id: <20080124224239.7f058278.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

FYI: Porting/rewriting a pcmcia driver that was working in 2.6.17 (PIO-based) to work on 2.6.24 (MMIO-based) and haven't been able
to make it work yet. I've used the good driver to extract values to compair against the new driver.

Bugtracked the issue abit more and found 2 strange factors.

1) Working 2.6.17 driver sets Vcc/Vpp = 30 while 2.6.24 sets it to 50 (using same card)
2) Working 2.6.17 driver uses 2->4 mem_maps while 2.6.24 only uses 1 (bad MAX_WIN?)

Other than that the output seems equal.
Any ideas?

Best wishes
Kristoffer

 
