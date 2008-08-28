Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYH1Opx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYH1Opx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYH1Opp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:45:45 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:50935 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752959AbYH1Opp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:45:45 -0400
Date: Thu, 28 Aug 2008 17:45:34 +0300
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200808281445.m7SEjYsB007502@burp.tkv.asdf.org>
To: Pavel Machek <pavel@suse.cz>
CC: linux-kernel@vger.kernel.org
In-reply-to: <20080828141826.GA6797@ucw.cz> (message from Pavel Machek on Thu,
	28 Aug 2008 16:18:27 +0200)
Subject: Re: Frustrated with capabilities..
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Pavel Machek <pavel@suse.cz>

> Yes, you need upcoming filesystem capabilities.  Binary may not
> inherit capabilities unless filesystem flags permit that.

I think this is wrong. Normal executables inherit uid/gid and
supplementary groups by default. Why should capabilities be any
different?

IMHO, even with file system capabilities, the default should be
inherit, if nothing else is specified.


