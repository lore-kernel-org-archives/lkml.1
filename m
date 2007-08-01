Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXHAGZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXHAGZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHAGZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:25:50 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36042 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXHAGZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:25:49 -0400
Date: Wed, 1 Aug 2007 15:25:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801062501.GB7581@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
> - Is anyone testing the kgdb code in here?
> 
Testing, yes. Succeeding, no. It's utterly hosed on SH in its present
condition at least. Presumably it's been tested on at least one platform
with some measure of success, but it's certainly not mine ;-)

I'll get you some patches that fix it up the rest of the way for SH
platforms in the next couple days. There's nothing too rough, though,
mostly serial driver fallout and changes in the current stub that aren't
reflected in the 'new' one.
