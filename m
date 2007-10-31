Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXJaW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXJaW3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXJaW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:29:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbXJaW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:29:25 -0400
Date: Wed, 31 Oct 2007 15:29:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: ebiederm@xmission.com, clg@fr.ibm.com, serue@us.ibm.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] The config option itself
Message-Id: <20071031152915.c0b57c73.akpm@linux-foundation.org>
In-Reply-To: <4728615D.5070700@openvz.org>
References: <47285FEE.9030001@openvz.org>
	<4728615D.5070700@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 14:05:01 +0300
Pavel Emelyanov <xemul@openvz.org> wrote:

> The option is called NAMESPACES. It can be selectable only
> if EMBEDDED is chosen (this was Eric's requisition). When
> the EMBEDDED is off namespaces will be on automatically.

I'm thinking that Eric's pidns-place-under-config_experimental.patch is for
2.6.24, so I attempted to rework your patches atop that but gave up on the
last one.

So if we're agreeeable, can you please redo these against next -mm, thanks.

Also, please do put a little thought into the choice of patch subjects. 
"the config option itself" will look rather dopey if it goes into the
permanent kernel record under that name.

Probably putting "CONFIG_NAMESPACES: " in front of each of these would
suit.

