Return-Path: <linux-kernel-owner+w=401wt.eu-S935250AbYBUWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250AbYBUWgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbYBUWgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:36:09 -0500
Received: from gw.goop.org ([64.81.55.164]:37567 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761518AbYBUWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:36:07 -0500
Message-ID: <47BDFC21.6010604@goop.org>
Date: Thu, 21 Feb 2008 14:33:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, dmitry.torokhov@gmail.com,
       virtualization@lists.osdl.org, linux-input@vger.kernel.org,
       adaplas@pol.net, akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: Re: [PATCH 0/2] xen pvfb: Para-virtual framebuffer,	keyboard and
 pointer
References: <871w76ejdg.fsf@pike.pond.sub.org>	<87hcg2cyti.fsf@pike.pond.sub.org> <47BDD4BF.3000808@goop.org> <871w76ca0i.fsf@pike.pond.sub.org>
In-Reply-To: <871w76ca0i.fsf@pike.pond.sub.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Armbruster wrote:
> Here's the description again:
>
>     Frontends are expected to write their protocol ABI to xenstore.  Since
>     the protocol ABI defaults to the backend's native ABI, things work
>     fine without that as long as the frontend's native ABI is identical to
>     the backend's native ABI.  This is not the case for xen-blkfront
>     running 32-on-64, because its ABI differs between 32 and 64 bit, and
>     thus needs this fix.
>
> I can break the dependency by putting the same bug that is now in
> xen-blkfront into xen-fbfront and xen-kbdfront.
>   

Right, I see.  The dependency is on the protocols.h changes.

    J
