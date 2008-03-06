Return-Path: <linux-kernel-owner+w=401wt.eu-S932851AbYCFWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbYCFWEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbYCFWEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:04:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45820 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbYCFWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:04:40 -0500
Date: Thu, 6 Mar 2008 23:06:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Haley <aph@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
       Michael Matz <matz@suse.de>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080306220610.GB31833@one.firstfloor.org>
References: <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net> <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org> <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com> <20080306173438.GH17267@synopsys.com> <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com> <47D05A70.40008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D05A70.40008@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 12:56:16PM -0800, H. Peter Anvin wrote:
> Richard Guenther wrote:
> >
> >A patched GCC IMHO makes only sense if it is always-on, yet another option
> >won't help in corner cases.  And corner cases is exactly what people seem
> >to care about.  For this reason that we have this single release, 4.3.0, 
> >that
> >behaves "bad" is already a problem.
> >
> 
> The option will help embedded vendors who can guarantee that it's not a 
> problem.

For very very low values of "help".

To be realistic it is very unlikely anybody will measure a difference
from a few more or a few less clds in a program. It's not that they're
expensive instructions and they normally don't happen in inner loops either.

"If you enable this option you will get an optimization that you cannot
measure" @)

-Andi
