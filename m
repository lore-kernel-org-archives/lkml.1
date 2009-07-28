Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZG1VeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZG1VeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZG1VeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:34:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbZG1VeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:34:23 -0400
Date: Tue, 28 Jul 2009 14:34:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       FlorianSchandinat@gmx.de, Scott Fang <ScottFang@viatech.com.cn>,
       Joseph Chan <JosephChan@via.com.tw>
Subject: Re: [PATCH] viafb: fix rmmod bug
Message-Id: <20090728143408.b1b6dba0.akpm@linux-foundation.org>
In-Reply-To: <1248538728-27344-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1248538728-27344-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(maintainers cc'ed)

On Sat, 25 Jul 2009 16:18:48 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> This fixes a bug caused by changing pointers (viafb_mode, viafb_mode1)
> assigned by module_param. It reduces driver complexity by not needlessly
> changing these vars as they are only read once and removing now
> superfluous code.

Can you please provide a better description of this bug?  What user
action triggers it, what effect is observed, what code defect caused
it, how the patch fixes it, etc?

Thanks.
