Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZLPStf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZLPStf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZLPSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:49:34 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:54345 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZLPStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:49:33 -0500
Date: Wed, 16 Dec 2009 19:49:32 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
Message-ID: <20091216184932.GB18410@boogie.lpds.sztaki.hu>
References: <20091216135448.GD11618@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216135448.GD11618@aftab>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 02:54:48PM +0100, Borislav Petkov wrote:

> Now, fixing this in the build system could get ugly and too much (see
> below), IMHO, so how about adding a README file in <tools/perf/>
> which explains that on Debian-like systems, one should mkdir
> /usr/include/libdwarf/ and symlink libdwarf.h and dwarf.h into it?
> 
> There could be a better solution though...?

Bug the libdwarf developers to ship a .pc file for pkg-config that
distros can customize as needed.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
