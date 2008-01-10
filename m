Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYAJGV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYAJGV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYAJGVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:21:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:55487 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYAJGVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TXRRPkV9hA/IarASvJ1L/F+Gwk9vz/mYq4W44rHu975CMtSsDcSrhfR88W6uz4CaUAkoT1f34Tv5Hd6GcjLD59zxRcPGHegK5qS46qqnCSC2iyemG+hgiuBqzCQD7qhahwCncrYZg9F4+ZkJoLZkjt+MB4fYh28AdITvKqdFC+M=
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
	traditional
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080109220508.686bbda4@laptopd505.fenrus.org>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 22:21:45 -0800
Message-Id: <1199946105.19760.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 22:05 -0800, Arjan van de Ven wrote:
> Subject: Make the 32 bit Frame Pointer backtracer fall back to traditional
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The 32 bit Frame Pointer backtracer code checks if the EBP is valid
> to do a backtrace; however currently on a failure it just gives up
> and prints nothing. That's not very nice; we can do better and still
> print a decent backtrace. 
> 
> This patch changes the backtracer to fall back to the non-framepointer
> backtracer if the EBP value isn't within the expected range; so on weird
> stack corruption cases we get at least something out...
> 

Arjan, I've been doing some work on traps_32.c porting over the
oops_begin()/oops_end()/_die() arrangement from traps_64.c and
then use it in unifying some more parts of fault.c.

If you have other work in this area, I'll hold off until your stuff
goes in...feel free to send me any work in progress stuff and I can
try to coordinate with you.

Harvey

