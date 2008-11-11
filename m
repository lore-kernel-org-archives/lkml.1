Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYKKAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYKKAu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYKKAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:50:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60052 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYKKAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:50:14 -0500
Date: Mon, 10 Nov 2008 16:49:28 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 3/5] adt7470: Check input range when sysfs files are
	written
Message-ID: <20081111004927.GO8668@plum>
Reply-To: djwong@us.ibm.com
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com> <20081107185636.13022.54109.stgit@elm3a70.beaverton.ibm.com> <20081110162214.b8202b60.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110162214.b8202b60.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 04:22:14PM -0800, Andrew Morton wrote:

> When writing changelogs, please explain _why_ a change was made, as
> well as what the change does.

Sorry about that.  Here's a revision:

Implement correct range checking for adt7470 to prevent userland from
writing impossible values into the chip, and cap out-of-range values per
standard hwmon conventions.

Implement correct rounding of input values per standard hwmon
conventions.

Is that better?

(Same goes for the adt7473 patch.)

> Looking at it, I guess it does change the userspace interface in minor
> ways, so we should merge it into 2.6.28.  Ditto
> adt7473-check-inputs-from-sysfs-writes.patch.  Agree?

Yes.

--D
