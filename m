Return-Path: <linux-kernel-owner+w=401wt.eu-S968226AbYD1XHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968226AbYD1XHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967328AbYD1WoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:44:21 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:5370 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967324AbYD1WoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:44:19 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, divy@chelsio.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.26 1/3] RDMA/cxgb3: Correctly serialize peer abort path.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
	<20080427160006.31018.66715.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 28 Apr 2008 15:44:17 -0700
In-Reply-To: <20080427160006.31018.66715.stgit@dell3.ogc.int> (Steve Wise's
	message of "Sun, 27 Apr 2008 11:00:06 -0500")
Message-ID: <adaprs9zjjy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 22:44:18.0042 (UTC) FILETIME=[646735A0:01C8A981]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, applied, with a few fixups based on checkpatch output -- mostly
__FUNCTION__ -> __func__ (__FUNCTION__ is a deprecated gcc-specific
extension, __func__ is standard), and also a couple "abort=0" -> "abort
= 0".

 - R.
