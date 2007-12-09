Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXLIVpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXLIVpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLIVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:44:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42739 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbXLIVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:44:55 -0500
Date: Sun, 9 Dec 2007 13:44:18 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jerry Geis <geisj@pagestation.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG in 2.6.23.9
Message-ID: <20071209134418.14c9f09d@laptopd505.fenrus.org>
In-Reply-To: <475C46BC.5020101@pagestation.com>
References: <475C46BC.5020101@pagestation.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Dec 2007 14:49:16 -0500
Jerry Geis <geisj@pagestation.com> wrote:

> I am using centos 5.1, 2.6.23.9 kernel. Machine works great all day.
> Then sometime through the night the kernel dies, the trace is below.

is this when a 3D screensaver is active?
Probably worth running without the proprietary nvidia driver.... it
also tends to get more people to pay attention :)


In addition to this suspicion; you're the first one to report this oops
since at least a year as shown in
http://www.kerneloops.org/guilty.php?guilty=journal_dirty_data&version=2.6.23-release&start=1540096&end=1572863

so it might well be something weird on your side (like the binary
driver or some heat problem created by having a 3D screensaver)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
