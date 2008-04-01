Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYDAIsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYDAIsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbYDAIru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:47:50 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60230 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbYDAIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:47:49 -0400
Date: Tue, 1 Apr 2008 01:47:47 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] Define sysfs interfaces for ibmaem driver
Message-ID: <20080401084747.GE7183@tree.beaverton.ibm.com>
References: <20080328213646.GC7191@tree.beaverton.ibm.com> <20080329145603.7e47418f@hyperion.delvare> <20080331210135.GC7183@tree.beaverton.ibm.com> <20080401102228.712acbb5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401102228.712acbb5@hyperion.delvare>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Got in a car accident tonight; replies will be scarce for the next week
or two.... :(]

On Tue, Apr 01, 2008 at 10:22:28AM +0200, Jean Delvare wrote:

> OK. Another question that comes to my mind now is the unit... Do the
> chips express the value in Joules internally? I would have expected
> Watt-hours. Of course we can convert as needed, but if all known chips
> use the same unit then I think we should that unit too, to minimize the
> required conversions.

The IBM chips report some form of Joules, not Wh.

> It really depends on what the chips report. Typically the drivers
> should report the values from the chip without too much tinkering
> (other than conversion to standard units). If some chips can report
> both "instantaneous" and "average" power uses, it makes sense to have
> both sets of filenames in the standard interface. If not then I am fine
> getting rid of one set.

Hmm, I'll think about what I want to do with this.  Probably just leave
them.

> I don't think there is any precedent yet. I suggested this for
> unambiguity rather than consistency.

Ok.

> Oh well, I guess that anything shorter than 1 ms can be considered
> "instantaneous power use", so we can go with millisecond.

Ok.

> Out of curiosity, what are the values supported by the ibmaem chip?

I don't know what the lower limits are; it depends on how often the BMC
decides to update the counters, and that seems to vary by machine.

--D
