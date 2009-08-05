Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZHEUWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZHEUWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZHEUWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:22:33 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:50132 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456AbZHEUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:22:32 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops less error-prone
Date: Wed, 5 Aug 2009 22:22:29 +0200
User-Agent: KMail/1.9.9
Cc: albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       elendil@planet.nl, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, daniel@caiaq.de
References: <20090803163304.GF5002@laptop> <20090805093758.GE5854@laptop> <200908052047.26293.rjw@sisk.pl> <200908052047.26293.rjw@sisk.pl> <200908052205.14222.rjw@sisk.pl>
In-reply-To: <200908052205.14222.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052222.31707.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 20:22:32.0308 (UTC) FILETIME=[76433340:01CA160A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> +struct dev_pm_ops name = { \
> +       .suspend = suspend_fn, \
> +       .resume = resume_fn, \
> +       .freeze = suspend_fn, \
> +       .thaw = resume_fn, \
> +       .poweroff = suspend_fn, \
> +       .resume = resume_fn, \

That defines .resume twice. Guess the last should be restore.

Cheers,
FJP
