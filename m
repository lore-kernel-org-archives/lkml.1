Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbXIFL3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbXIFL3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbXIFL2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:28:53 -0400
Received: from gw.goop.org ([64.81.55.164]:43292 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbXIFL2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:28:53 -0400
Message-ID: <46DFE46F.5020001@goop.org>
Date: Thu, 06 Sep 2007 12:28:47 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, shaohua.li@intel.com,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC]: pte notifiers -- support for external page tables
References: <11890103283456-git-send-email-avi@qumranet.com> <46DEFDF4.5000900@redhat.com> <46DF0013.4060804@qumranet.com> <46DF0234.7090504@redhat.com> <46DF045F.4020806@qumranet.com>
In-Reply-To: <46DF045F.4020806@qumranet.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> It is, but the hooks are in much the same places.  It could be argued
> that you'd embed pte notifiers in paravirt_ops for a host kernel, but
> that's not doable because pte notifiers use higher-level data
> strutures (like vmas).

Also, I wouldn't like to preclude the possibility of having a kernel
that's both a guest and a host (ie, nested vmms).

    J
