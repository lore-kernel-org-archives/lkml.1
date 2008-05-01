Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbYEAMya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbYEAMya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758753AbYEAMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:54:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46642 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256AbYEAMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:54:05 -0400
Date: Thu, 1 May 2008 13:53:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression
	warnings
Message-ID: <20080501125339.GX5882@ZenIV.linux.org.uk>
References: <1209593024.24729.119.camel@brick> <4819ACF6.9000403@panasas.com> <20080501120016.GV5882@ZenIV.linux.org.uk> <4819BAA6.9030105@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4819BAA6.9030105@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:42:14PM +0300, Boaz Harrosh wrote:
> > 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> > a function whose return type is void.
> > 
> 
> Please forgive my ignorance, where is this quote from?

C99.  I don't have C90 in front of me, so I can't give you exact quote from
there, but it's been explicitly banned in C90 as well.
