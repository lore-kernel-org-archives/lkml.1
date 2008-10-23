Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYJWMia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYJWMia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJWMiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:38:22 -0400
Received: from welcomes-you.com ([85.214.50.128]:39966 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYJWMiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:38:21 -0400
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2008 08:38:21 EDT
Message-ID: <49006A30.7030208@aei.mpg.de>
Date: Thu, 23 Oct 2008 14:12:32 +0200
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Henning Fehrmann <henning.fehrmann@aei.mpg.de>
Subject: Idle core on overloaded CPU?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on Intel X3220 CPU based systems (4 physical cores) I came across the
following thing (Debian etch, with vanilla kernel 2.6.25.9):

starting the following:
$ screen -d -m stress -c 2
$ nice -19 screen -d -m stress -c 4

This causes two cores to be 100% busy in user state and one core to be
busy in 100% nice state. However, the remaining core is idle. Even
watching it over longer stretches of time, the situation remains static.

I guess it's a kernel misconfiguration on my part (config available here:
https://n0.aei.uni-hannover.de/linux/kernel/config-2.6.25.9-nodes
), but if not could this be a scheduling bug?

Thanks for any hint

Cheers

Carsten
