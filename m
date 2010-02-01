Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BAOl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:41:56 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:41082 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0BAOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:41:55 -0500
Date: Mon, 1 Feb 2010 15:41:49 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending
 devices
In-Reply-To: <201001252237.42545.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1002011527580.5334@localhost>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201001222148.23945.rjw@sisk.pl> <alpine.LFD.2.00.1001251601440.2100@localhost> <201001252237.42545.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

since you didn't like the idea of calling the driver callbacks with just
one cpu enabled, we gave your patch: "MM / PM: Force GFP_NOIO during
suspend/hibernation and resume" a try and i can confirm that this
fixes the issue on s390. Will this go in 2.6.33/stable?

greetings,
Sebastian
