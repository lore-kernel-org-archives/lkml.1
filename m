Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXJIQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXJIQVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXJIQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:21:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXJIQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:21:07 -0400
Date: Tue, 9 Oct 2007 17:21:03 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] device-mapper: fix bd_mount_sem corruption
Message-ID: <20071009162103.GW10006@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <470ABDE5.30200@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470ABDE5.30200@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 07:31:49PM -0400, Jun'ichi Nomura wrote:
> This patch fixes a bd_mount_sem counter corruption bug in device-mapper.

[summary of follow-up]

Affects 2.6.16 (and 2.6.15.5) upwards if someone removes a suspended device
(which shouldn't happen during normal lvm2 operation).

Alasdair
-- 
agk@redhat.com
