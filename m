Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbYAKUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbYAKUJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbYAKUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:09:21 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52640 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbYAKUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:09:21 -0500
Date: Fri, 11 Jan 2008 21:09:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/mkmakefile: dynamic determination of output directory
Message-ID: <20080111200926.GD29189@uranus.ravnborg.org>
References: <4787403C.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4787403C.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 09:09:00AM +0000, Jan Beulich wrote:
> Rather than fixing the output directory in the generated Makefile,
> determine it from the placement of Makefile. This allows moving
> the build tree around or accessing it through different mount paths.
> 
> (The lastword definition is a compatibility one for make prior to 3.81;
> newer make will simply ignore it and use the [faster] built-in.)

Thanks, applied.

	Sam
