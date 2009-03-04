Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZCDOM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZCDOM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCDOMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:12:45 -0500
Received: from stinky.trash.net ([213.144.137.162]:38569 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCDOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:12:45 -0500
Message-ID: <49AE8C57.4080502@trash.net>
Date: Wed, 04 Mar 2009 15:12:39 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: lguest: unhandled trap 13 in current -rc
References: <4993CCCE.6040403@trash.net>
In-Reply-To: <4993CCCE.6040403@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> When trying to run lguest in the current -rc, I get an "unhandled
> trap 13" and it stops. The address resolves to the rdmsr intruction
> in native_read_msr_safe(). -rc2 works fine, but I couldn't find
> any changes that looks related.
> 
> .config is attached, more information available on request.

For the record, this is still broken in -rc7.
