Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZJARs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZJARs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbZJARs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:48:26 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45587 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbZJARsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:48:25 -0400
Message-ID: <4AC4EB2E.4050907@s5r6.in-berlin.de>
Date: Thu, 01 Oct 2009 19:47:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Nathaniel McCallum <nathaniel@natemccallum.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Exposing device ids and driver names
References: <4AC4DB65.8070404@natemccallum.com>
In-Reply-To: <4AC4DB65.8070404@natemccallum.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel McCallum wrote:
> Please CC me on any responses as I'm not subscribed to lkml.
> 
> I have the aim at creating two tools helpful to linux.  The first tool 
> is a driver regression test of sorts.  I want to be able to create 
> essentially a time line of hardware support as they appear in distros. 
> The second tool, related to the first, is a program which runs on 
> Windows and scans for a user's hardware and tells them which distro will 
> best support their hardware.  I already have a working prototype of 
> these two tools.  It currently uses the data exported by modinfo.  This 
> however does not provide transparency for drivers compiled into the kernel.

Hardware support also depends on userland:  Udev rules, libraries,
application programs.

Even if you ignore that for now and only look at the kernel part of
hardware support:  Beyond "doesn't have a matching driver" and "does
have", there is a large and impossible to track grey area of "has a
poorly working driver" and "has a perfectly working driver".
-- 
Stefan Richter
-=====-==--= =-=- ----=
http://arcgraph.de/sr/
