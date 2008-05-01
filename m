Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYEAMwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYEAMwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYEAMv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:51:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46629 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYEAMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:51:56 -0400
Date: Thu, 1 May 2008 13:51:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression
	warnings
Message-ID: <20080501125143.GW5882@ZenIV.linux.org.uk>
References: <1209593024.24729.119.camel@brick> <4819ACF6.9000403@panasas.com> <20080501120016.GV5882@ZenIV.linux.org.uk> <1209644226.16449.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209644226.16449.11.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:17:06PM +0200, Peter Zijlstra wrote:
> > Write in C, please.
> 
> We use GNU99 all over the place, or are you going to clear up all the
> statement expressions and such other fancy gnu extensions to the
> language as well?

Worthless ones - sure.  Statement expressions are not particulary
nice one, but we can't avoid that shit (note that they are not even
well-defined - you can easily make gcc fall over and die with those).
