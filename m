Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbXBVSgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbXBVSgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXBVSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:36:30 -0500
Received: from colin.muc.de ([193.149.48.1]:4213 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbXBVSga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:36:30 -0500
Date: 22 Feb 2007 19:36:28 +0100
Date: Thu, 22 Feb 2007 19:36:28 +0100
From: Andi Kleen <ak@muc.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -freg-struct-return?
Message-ID: <20070222183628.GA65601@muc.de>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222112207.GA10190@muc.de> <45DDC810.3000401@zytor.com> <45DDD538.1040309@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDD538.1040309@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 09:39:04AM -0800, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
> > Sometimes returning small structures is really nice.  If you can pass
> > them in registers, it's often generates the fastest possible code;
> > much better than using a pointer. 
> 
> Yes, but specifically, are there any pieces of assembler which return
> structures?  It appears there are none (since Ingo got a booting
> kernel), but there might be something obscure in some corner.

When I did the x86-64 port I went over all assembler and I can't remember
anything that did that. Of course there might be out of tree drivers
that do, but they just have to fix it up.

BTW would it make sense to have a special announcement list for such changes?

-Andi
