Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZJCWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZJCWcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 18:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZJCWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 18:32:49 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:37109 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZJCWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 18:32:48 -0400
Date: Sun, 4 Oct 2009 00:32:10 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091003223210.GA4193@boogie.lpds.sztaki.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
 <20091003110546.78958508@infradead.org>
 <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 12:04:03AM +0200, Matteo Croce wrote:

> yes cmov and i686 are unrelated but some distros (Debian & co.)
> compiles libraries for two archs:
> i486 and i686-cmov so only i686 machines does benefit from cmov.
> This is why I cared about having an i686 aware userspace but it seems
> that for a missing instruction I can't do that

You could emulate the missing instruction. As long as it is not really
used, the performance cost of the emulation should not matter. Of course
if userspace starts to use long NOPs extensively then it becomes a
problem.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
