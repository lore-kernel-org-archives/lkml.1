Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYBRVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYBRVEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYBRVDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:43 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11867 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYBRVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:42 -0500
Date: Mon, 18 Feb 2008 13:03:13 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Kurt Hackel <kurt.hackel@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] ocfs2: le*_add_cpu conversion
Message-ID: <20080218210313.GB22671@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:06:18AM +0100, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch


Thanks, this is in ocfs2.git now.
	--Mark
--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
