Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZLII3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZLII3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZLII3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:29:00 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:4219 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZLII27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:28:59 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 03:28:59 EST
Date: Wed, 9 Dec 2009 09:22:56 +0100
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091209082256.GA21505@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com> <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com> <4B1D988E.2000305@gmail.com> <20091208015148.GK14381@ZenIV.linux.org.uk> <4B1EEE42.6090202@gmail.com> <20091209004734.GO14381@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209004734.GO14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 12:47:34AM +0000, Al Viro wrote:
> What you really want is
> 	* no conversions to any other pointer types for pointers to it
> and to any aggregate types containing it
> 	* no conversions from any other pointer types for the same set of
> types
> 	* all objects of that type have static storage duration
> 	* no lvalues of that type are modifiable

What about the ->owner field?

  OG.
