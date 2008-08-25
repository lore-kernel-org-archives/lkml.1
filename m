Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYHYKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYHYKDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYHYKDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:03:39 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:49914 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYHYKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:03:39 -0400
Message-ID: <48B282E8.4070807@hypersurf.com>
Date: Mon, 25 Aug 2008 03:01:12 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] A a cpufreq driver for the IBM PowerPC 750GX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a cpufreq driver for the IBM PowerPC 750GX processor. It
"should" also work for the 750FX. The patches are:

	1) Add low level PLL config register interface module
	2) Add cpufreq driver for the 750GX
	3) Other PowerPC kernel changes necessary to support the above
	4) Add kernel doc for the completion feature, fix split-man.pl in
	   kernel-doc-nano-HOWTO.txt

These changes are against 2.6.26.
