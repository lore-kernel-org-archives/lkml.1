Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYEAMAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYEAMAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYEAMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:00:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42185 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbYEAMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:00:23 -0400
Date: Thu, 1 May 2008 13:00:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/10] misc: fix returning void-valued expression
	warnings
Message-ID: <20080501120016.GV5882@ZenIV.linux.org.uk>
References: <1209593024.24729.119.camel@brick> <4819ACF6.9000403@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4819ACF6.9000403@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:43:50PM +0300, Boaz Harrosh wrote:

> I don't know who invented sparse, but I like this form of return.
> 1 - It saves me the curly brackets and extra return line. But mainly
> 2 - It is a programing statement that says: "Me here I'm an equivalent 
>   to that other call". So if in the future that inner function starts
>   to return, say, an error value, with the first style the compiler will
>   error. But with the second style the new error return will be silently
>   ignored. So these are not equivalent replacements. The former is a much
>   stronger bond between the caller and the callie.

3.  6.8.6.4(1): A return statement with an expression shall not appear in
a function whose return type is void.

Write in C, please.
