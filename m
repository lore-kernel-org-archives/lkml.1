Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbYJPSsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbYJPSsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYJPSsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:48:23 -0400
Received: from mailout04.t-online.de ([194.25.134.18]:59860 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYJPSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:48:22 -0400
Message-ID: <48F78C5C.8080907@t-online.de>
Date: Thu, 16 Oct 2008 20:47:56 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.1: install conflict about /lib/firmware
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: SUGvRMZUYhPD4jcAyARqefxfu72ioyx4N7RTkjrHLkxpSBNo09G7cZ97LrDDtXjQbv
X-TOI-MSGID: f80ed143-87c7-4df4-acc7-96daa479e80c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Seems that there is an installation conflict about
/lib/firmware/ess/maestro3_assp_kernel.fw (and probably
others) between 2.6.27 and 2.6.27.1. Using dpkg I get

:
Unpacking raw-kernel-2.6.27.1 (from .../raw-kernel-2.6.27.1_2.6.27.1-0_amd64.deb) ...
dpkg: error processing /var/cache/apt/archives/raw-kernel-2.6.27.1_2.6.27.1-0_amd64.deb (--unpack):
 trying to overwrite `/lib/firmware/ess/maestro3_assp_kernel.fw', which is also in package raw-kernel-2.6.27
dpkg-deb: subprocess paste killed by signal (Broken pipe)
Errors were encountered while processing:
 /var/cache/apt/archives/raw-kernel-2.6.27.1_2.6.27.1-0_amd64.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)
A package failed to install.  Trying to recover:


Probably other package managers get a similar problem.

Wouldn't it be more consistent to put the firmware files in a
kernel specific directory, e.g. in /lib/firmware/2.6.27.1 or
/lib/modules/2.6.27.1/firmware ?


Regards

Harri

