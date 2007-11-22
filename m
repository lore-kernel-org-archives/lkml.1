Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbXKVLvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbXKVLvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXKVLv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:51:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:59602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXKVLv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:51:27 -0500
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 22 Nov 2007 12:46:23 +0100
User-Agent: KMail/1.9.1
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <200711221456.22297.rusty@rustcorp.com.au>
In-Reply-To: <200711221456.22297.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221246.23994.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007 04:56, Rusty Russell wrote:

>     This is an interesting idea, thanks for the code!  My only question is
> whether we can get most of this benefit by dropping the indirection of
> namespaces and have something like "EXPORT_SYMBOL_TO(sym, modname)"?  It
> doesn't work so well for exporting to a group of modules, but that seems
> a reasonable line to draw anyway.

That would explode quickly already even for my example "inet" namespace.
It already has several modules.  I don't think so much duplication would be a 
good idea.

-Andi
