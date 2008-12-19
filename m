Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYLSXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYLSXmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYLSXmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:42:03 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:2889 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLSXmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:42:01 -0500
Message-ID: <8bb80c380812191542g72b541b3s14001aaa234e79cc@mail.gmail.com>
Date: Fri, 19 Dec 2008 15:42:00 -0800
From: "Mike Chan" <mike@android.com>
To: linux-kernel@vger.kernel.org
Subject: per uid based resource tracking
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bunch of patches that export resource tracking per-pid
(which you can effectively map back to uid). However if you are
collecting aggregated stats, this requires polling from userspace in
case you have processes that die or the kernel oom killer kicks in and
you lose that stats.

What are people's thoughts on yet another stats in either /proc or
/sys to export resources (network, cpu, io) aggregated per uid. Or
does this already exist in 2.6.27 somewhere?

-- 
MIke Chan
