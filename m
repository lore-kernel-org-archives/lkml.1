Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZGOKlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZGOKlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZGOKlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:41:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43032 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZGOKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:41:38 -0400
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 0/8] device async action mechanism
From: Andi Kleen <andi@firstfloor.org>
References: <1247643512.26272.74.camel@rzhang-dt>
Date: Wed, 15 Jul 2009 12:41:33 +0200
In-Reply-To: <1247643512.26272.74.camel@rzhang-dt> (Zhang Rui's message of "Wed, 15 Jul 2009 15:38:32 +0800")
Message-ID: <87ocrm6xeq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui <rui.zhang@intel.com> writes:
>
> Currently, in order to make sure that it won't bring any side effects,
> I only convert the ACPI battery and i8042 to use this framework, which reduces
> 0.5s+ S3 time(suspend time plus resume time)﻿, from 7.0s to less than 6.5s.

10.5s+ was intended I guess?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
