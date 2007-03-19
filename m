Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbXCSVXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbXCSVXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXCSVXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:23:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10328 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXCSVXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:23:04 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01 of 33] IB/ipath - add ability to set and clear IB local loopback
X-Message-Flag: Warning: May contain useful information
References: <b1d05f3486f8bba1dd3c.1173995085@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Mar 2007 14:22:56 -0700
In-Reply-To: <b1d05f3486f8bba1dd3c.1173995085@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:44:45 -0700")
Message-ID: <adar6rllyhb.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Mar 2007 21:22:56.0338 (UTC) FILETIME=[C2F7CB20:01C76A6C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch format is somewhat inconvenient:

 > # HG changeset patch
 > # User Bryan O'Sullivan <bos@pathscale.com>

I assume this is the real author of the patch (as opposed to the
sender of the email)?  git would prefer to see

From: Bryan O'Sullivan <bos@pathscale.com>

in the body of the email.

 > # Date 1173994464 25200
 > # Node ID b1d05f3486f8bba1dd3c5cbca39f06a5e1b3d6fb
 > # Parent  0d37971d4ab0c8b6f7a8f6e8222112321982498f

And all of these "#" lines get put into the patch description.

 > IB/ipath - add ability to set and clear IB local loopback

No need to duplicate the subject line.

And incidentally, it would be better to use "IB/ipath: " instead of
"IB/ipath -" as a prefix, to match the canonical style of
"<subsystem>: " for patch headers.

Don't worry about resending, I can fix this up, but it would be nice
not to have to worry about it.
