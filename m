Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYD0EVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYD0EVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYD0EVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:21:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57234 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYD0EVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:21:08 -0400
Date: Sun, 27 Apr 2008 05:20:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080427042051.GL5882@ZenIV.linux.org.uk>
References: <1209268817.14173.43.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209268817.14173.43.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 09:00:17PM -0700, Harvey Harrison wrote:
> As written, this can never be true.

... and introduced through x86.git, of all things...  May I suggest that
in addition to all-important whitespace hunting something that catches
lowly real bugs would also be run over that tree?  sparse *does* catch
that...
