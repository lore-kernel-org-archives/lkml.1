Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbYKGUfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbYKGUfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYKGUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:35:26 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:19436 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGUfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:35:25 -0500
Date: Fri, 7 Nov 2008 21:35:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 4/5] adt7473: Check inputs from sysfs writes
Message-ID: <20081107213513.2f347fca@hyperion.delvare>
In-Reply-To: <20081107112040.0154e093.akpm@linux-foundation.org>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
	<20081107112040.0154e093.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 11:20:40 -0800, Andrew Morton wrote:
> On Fri, 07 Nov 2008 10:56:41 -0800
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > +#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
> 
> It might make sense to rename this to ROUND_CLOSEST, fix the
> double-evaluation and whap it into kernel.h?

To be consistent with DIV_ROUND_UP, I'd rather name the new function
DIV_ROUND_CLOSEST. But other than that, yes I agree that making this an
inline function and moving it to kernel.h would be a good idea. Many
many hwmon drivers use this and people keep asking about this construct.

-- 
Jean Delvare
