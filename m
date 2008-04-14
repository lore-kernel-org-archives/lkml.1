Return-Path: <linux-kernel-owner+w=401wt.eu-S1761247AbYDNXCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247AbYDNXCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYDNXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:02:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58943 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYDNXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:02:16 -0400
Date: Tue, 15 Apr 2008 00:02:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-mm 15/15] ncpfs: Use get/put_unaligned_* helpers
Message-ID: <20080414230213.GC9785@ZenIV.linux.org.uk>
References: <1208213283.11920.46.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208213283.11920.46.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 03:48:03PM -0700, Harvey Harrison wrote:
> -	return le16_to_cpu(get_unaligned((__le16*)data));
> +	return le16_to_cpu(get_unaligned_le16(data);

and

> -	return le16_to_cpu(get_unaligned((__le16 *) ncp_reply_data(server, offset)));
> +	return get_unaligned_le16(ncp_reply_data(server, offset));

Compare...
