Return-Path: <linux-kernel-owner+w=401wt.eu-S1030605AbXBMArX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030605AbXBMArX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030611AbXBMArX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:47:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3421 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030605AbXBMArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:47:22 -0500
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
	to "array_for_each(index, array)"
From: Joe Perches <joe@perches.com>
To: Ben Nizette <ben.nizette@iinet.net.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D10460.6000903@iinet.net.au>
References: <1171324070.1528.25.camel@localhost>
	 <45D10460.6000903@iinet.net.au>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 16:47:27 -0800
Message-Id: <1171327648.1528.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 11:20 +1100, Ben Nizette wrote:
>   #define array_for_each(element, array) \
> 	for (int __idx = 0; __idx < ARRAY_SIZE((array)); \
> 		__idx++, (element) = &(array[__idx]))

This requires all interior loop code be changed.

