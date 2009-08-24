Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZHXVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZHXVIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZHXVIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZHXVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:08:18 -0400
Date: Mon, 24 Aug 2009 14:07:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, rydberg@euromail.se
Subject: Re: [PATCH] hwmon: applesmc: restore keyboard backlight on resume
Message-Id: <20090824140717.e7011b8c.akpm@linux-foundation.org>
In-Reply-To: <1250976832-9801-1-git-send-email-rydberg@euromail.se>
References: <1250976832-9801-1-git-send-email-rydberg@euromail.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 23:33:52 +0200
"Henrik Rydberg" <rydberg@euromail.se> wrote:

> On resume from suspend, the driver currently resets the logical
> state as if it was brought up from halt. This patch uses the
> dev_pm_ops.resume method to synchronize the hardware with the
> memorized logical state, bringing back the backlight to the level
> prior to suspend.

What are the runtime effects of this change?
