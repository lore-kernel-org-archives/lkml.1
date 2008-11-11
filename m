Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYKKAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYKKAXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYKKAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:22:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYKKAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:22:51 -0500
Date: Mon, 10 Nov 2008 16:22:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: djwong@us.ibm.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 3/5] adt7470: Check input range when sysfs files are
 written
Message-Id: <20081110162214.b8202b60.akpm@linux-foundation.org>
In-Reply-To: <20081107185636.13022.54109.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185636.13022.54109.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 10:56:36 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Subject: [PATCH 3/5] adt7470: Check input range when sysfs files are written
> 
> Implement correct rounding and range checking for adt7470.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

When writing changelogs, please explain _why_ a change was made, as
well as what the change does.

Coz I'm sitting here wondering if we need this in 2.6.28 and I don't
have all the information.

Looking at it, I guess it does change the userspace interface in minor
ways, so we should merge it into 2.6.28.  Ditto
adt7473-check-inputs-from-sysfs-writes.patch.  Agree?

