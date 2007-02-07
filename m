Return-Path: <linux-kernel-owner+w=401wt.eu-S1161189AbXBGLHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161189AbXBGLHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 06:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161136AbXBGLHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 06:07:44 -0500
Received: from [221.219.160.65] ([221.219.160.65]:47237 "EHLO
	freya.yggdrasil.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161189AbXBGLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 06:07:43 -0500
X-Greylist: delayed 832 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 06:07:43 EST
Date: Wed, 7 Feb 2007 18:55:53 +0800
From: "Adam J. Richter" <adam@yggdrasil.com>
Message-Id: <200702071055.l17AtrZf014135@freya.yggdrasil.com>
To: Stephen.Clark@seclark.us
Subject: Re: hdparm for lib_pata
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-02-04 Stephen Clark wrote:
>I have had two different laptops that had to have boot time command line 
>overrides to get the
>driver to allow the hardware work at what it was spec-ed at.

	Do you know if these drives were advertising less capability
than they were spec-ed at?  Do you recall if the IDE driver without
kernel arguments printed its rationale for reverting to the slower
setting?

	I ask because I'd like to know if this sort of thing can ever
happen with libata.  If so, then that is yet another reason to have
the ability to override DMA settings from user level in libata.

Adam Richter
