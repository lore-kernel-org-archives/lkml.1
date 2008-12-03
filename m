Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYLCXdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYLCXdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYLCXdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:33:40 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:2453 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYLCXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:33:40 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [solved] .28-rc7-91 Starting X.Org fails and display hangs
Date: Thu, 4 Dec 2008 00:33:37 +0100
User-Agent: KMail/1.9.9
References: <200812031619.41679.elendil@planet.nl>
In-Reply-To: <200812031619.41679.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040033.37542.elendil@planet.nl>
X-OriginalArrivalTime: 03 Dec 2008 23:33:38.0335 (UTC) FILETIME=[915752F0:01C9559F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008, Frans Pop wrote:
> Just booted my HP 2510p with v2.6.28-rc7-91-gf6f7b52 and got a rather
> nasty failure:
> - last message on console is Starting kdm
> - screen blanks (as normal before switch to kdm on VT7)
> - system is alive: can ssh to it
> - rebooting the system fails; hard poweroff needed
>
> .28-rc6-209 boots without problems.
>
> Diff of X.Org logs (see below) shows it just stops at some point. There
> are no changes in the log before the failure point.

Caused by same commit as: http://lkml.org/lkml/2008/12/3/456
