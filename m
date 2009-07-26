Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZGZUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZGZUwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 16:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZGZUwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 16:52:44 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:53499 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbZGZUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 16:52:43 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
Date: Sun, 26 Jul 2009 22:52:39 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Erik Ekman <erik@kryo.se>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090701083737.41f28c7d.erik@kryo.se> <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com> <200907262145.46363.rjw@sisk.pl>
In-Reply-To: <200907262145.46363.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907262252.41429.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jul 2009 20:52:42.0194 (UTC) FILETIME=[04E86320:01CA0E33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Rafael J. Wysocki wrote:
> In fact, I wouldn't advise anyone to do these conversions mechanically.

With hindsight I'd say you are correct.

In that case would it maybe have been better to have a build time warning 
about the need to convert drivers rather than a run time one? Run time 
warnings have a much higher annoyance factor and will thus "invite" more 
people into having a shot at getting rid of them.

But I guess partly it's also just the nature of this change: it looks 
trivial due to the corresponding terms.
