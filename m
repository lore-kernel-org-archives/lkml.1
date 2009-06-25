Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZFYRpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZFYRpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZFYRp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:45:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47411 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZFYRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:45:28 -0400
Date: Thu, 25 Jun 2009 19:47:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle Hubert <khubert@cray.com>
Cc: linux-kernel@vger.kernel.org, Igor Gorodetsky <igorodet@cray.com>
Subject: Re: 2.6 Makefile replacement for VPATH
Message-ID: <20090625174748.GA15168@uranus.ravnborg.org>
References: <20090625163916.GN6248@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625163916.GN6248@cray.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I refer to VPATH with regards to the situation where you can have
> multiple Makefiles target the same source file to build different
> objects. In particular, we are using the same source file recompiled
> with different options to be able to support different devices.

Several obvious solutions.

a) Let the same driver handle multiple devices - we do this in very often.

b) Keep all shared functionality in a dedicated lib* module, and
have thin wrappers for the actual drivers. See libata for example.

c) The ugly where you have a thin dedicated .C file for each driver
that includes the source they share.

> How do others handle this? Do they just move their driver outside of
> the kernel Makefiles so they can iterate through the two builds via
> traditional Make routines?
That will most likely not work.

	Sam
