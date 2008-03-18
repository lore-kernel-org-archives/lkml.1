Return-Path: <linux-kernel-owner+w=401wt.eu-S939059AbYCSVvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939059AbYCSVvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764491AbYCSUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:20:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbYCSUUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:20:07 -0400
Message-ID: <47E051F2.4010804@redhat.com>
Date: Tue, 18 Mar 2008 19:36:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Shaohua Li <shaohua.li@intel.com>
Subject: intel_iommu causes kernel panic on some hardware
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this known?

Description of problem:
The latest Fedora kernel 2.6.24.3-12.fc8 fails to boot with:

Kernel panic - not syncing: DMAR hardware is malfunctioning

https://bugzilla.redhat.com/show_bug.cgi?id=436899

Should the kernel panic or just continue without using the DMAR hardware?
