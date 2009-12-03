Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZLCEGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZLCEGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZLCEGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:06:24 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:58134 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZLCEGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:06:24 -0500
Date: Wed, 02 Dec 2009 23:06:19 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Bug (minor): microcode_intel.c applies updates to hyperthreaded cores
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B17393B.7000304@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to spec, microcode should only be applied to actual cores. As
things are currently structured, looks like the fix would be in
microcode_core.c. I don't think changing the loop to look for cores vs.
cpu's would affect anything adversely, but honestly am not familiar
enough with this code or other cpu types to be sure.

As far as I can tell, the only adverse impact of this issue is boot
performance in the event that microcode is applied to a large number of
processors in a hyper-threaded environment. I've only got one chip, so
no real issues here. Just happened to notice.

