Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXCSVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXCSVXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXCSVXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:23:50 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:12294 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXCSVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:23:49 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33 of 33] IB/ipath - fix drift between WCs in user and kernel space
X-Message-Flag: Warning: May contain useful information
References: <e61b0123190cfbc01cc3.1173995117@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Mar 2007 14:23:48 -0700
In-Reply-To: <e61b0123190cfbc01cc3.1173995117@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:45:17 -0700")
Message-ID: <adamz29lyfv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Mar 2007 21:23:48.0508 (UTC) FILETIME=[E2104DC0:01C76A6C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For example this seems like it should go in 2.6.21 -- otherwise
userspace verbs are completely broken with ipath, right?  It's really
my fault for breaking it, but I don't see why we want to release with
a bug like that.

 - R.
