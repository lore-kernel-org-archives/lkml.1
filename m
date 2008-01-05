Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYAETvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYAETvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYAETvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:51:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37556 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbYAETvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:51:43 -0500
Date: Sat, 5 Jan 2008 20:51:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: Re: [PATCH 1/3 v2] Merge mkubootimg tool for building U-Boot images
Message-ID: <20080105195145.GA9814@uranus.ravnborg.org>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com> <20080103160244.6a28519b@zod.rchland.ibm.com> <20080104161336.GB31026@uranus.ravnborg.org> <20080104112609.6b678ccc@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104112609.6b678ccc@zod.rchland.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 11:26:09AM -0600, Josh Boyer wrote:
> Several platforms require the mkimage tool to generate a uImage file that is
> used with U-Boot.  This brings the mkimage tool in-kernel to enable building
> those platforms without having mkimage externally provided.  The tool is named
> mkubootimg for better clarity.
> 
> This is currently based off of the version found in U-Boot 1.3.1.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

I added following comment to the changelog:
======
Note: This patchs trigger followings output from checkpatch.pl:
total: 45 errors, 144 warnings, 1097 lines checked

As this is based on a copy of SW from U-boot this is accepted as an
exception.
======

Next time please indicate result of checkpatch.pl run.
Usually I does not accept errors from checkpatch.pl (unless
checkpatch.pl has become utterly confused).

And I added Wolfgang as Cc:

	Sam

