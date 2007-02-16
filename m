Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXBPGEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXBPGEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932958AbXBPGEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:04:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44315 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957AbXBPGEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:04:09 -0500
Message-ID: <45D54958.40405@vmware.com>
Date: Thu, 15 Feb 2007 22:04:08 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
References: <20070216022449.739760547@goop.org> <20070216022531.047039320@goop.org>
In-Reply-To: <20070216022531.047039320@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Remove the ctor for the pgd cache.  There's no point in having the
> cache machinery do this via an indirect call when all pgd are freed in
> the one place anyway.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>   

Acked-by: Zachary Amsden <zach@vmware.com>

This does introduce a bug for us, but that is trivially fixed, and I 
would like to inspect final merged code to make sure bugfix is proper.

Zach
