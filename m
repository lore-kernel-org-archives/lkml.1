Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbYBBWys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbYBBWys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763638AbYBBWyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:54:41 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:24031 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763559AbYBBWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=a7LWBs0PX/imyawGaUcNXx6FUhXMTdnkYhBi7NurXXVipU9ROUd2InUA9OcCbbQ54qUnbHw5SDFjWfs6geyHxGDFFlsUi0VV4yRq9ndB+19LRbSkXaBV2Gud62ws69WmCxDTC88dPYkMZ5dldxS1vw9vllzMGisRILWIptqAo2s=
Date: Sun, 3 Feb 2008 01:54:34 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Generic clocks framework
Message-ID: <20080202225433.GA14685@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently we have a generic clock api for using clocks.
This patchset tries to fill other side: an api for providing
clocks.
Currently each platform that wants to provide <linux/clk.h>
implementation is forced to reimplement everything from scratch.
This leads for major code duplication. E.g. the ARM arch
contains 13 implementations (one for each mach). Also there are
implementations for AVR, MIPS, PowerPC and SH.

This patchset implements the "management" part, so each platform
would have to only implement few platform-specific parts.

-- 
With best wishes
Dmitry

