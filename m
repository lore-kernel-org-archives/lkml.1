Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYAERtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYAERtG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYAERss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:48:48 -0500
Received: from main.gmane.org ([80.91.229.2]:47827 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbYAERsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:48:47 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: JustFillBug <mozbugbox@yahoo.com.au>
Subject: Why is "GoTop Super_Q2/GogoPen/PenPower tablets" treated as touchscreen?
Date: Sat, 5 Jan 2008 17:48:39 +0000 (UTC)
Message-ID: <slrnfnvgnn.7sl.mozbugbox@mozbugbox.somehost.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cm125-59-81-236.hkcable.com.hk
X-Mail-Copies-To: nobody
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the commit:
===========
author Jerrold Jones <digireco@gmail.com>
Mon, 22 Oct 2007 04:59:47 +0000 (00:59 -0400)
committer Dmitry Torokhov <dmitry.torokhov@gmail.com>
Mon, 22 Oct 2007 04:59:47 +0000 (00:59 -0400)
committer Dmitry14e4020630b364cc564172a476cd6a6ac4bc7393
tree 08c56cb99138275991993b62bb28ce3b92dee833 tree | snapshot
parent 858711c55f757872b11574599bfa836df8ab34c9 commit | diff
Input: usbtouchscreen - add support for GoTop tablet devices

Add support for GoTop Super_Q2/GogoPen/PenPower tablets to usbtouchscreen.
Protocol discovery was done by Yick Yan Lam.
==========

The tablets were added as touchscreen devices instead of tablets. The
tablets have some buttons while touch screen has no button. As a result,
the buttons on the tablets will not function when treated as
touchscreen.

Shouldn't the tablets be add to one of the device in the input/tablet/
directory, like wacom, instead of input/touchscreen?


