Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYAXGp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYAXGp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYAXGpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:45:18 -0500
Received: from gw.goop.org ([64.81.55.164]:58706 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYAXGpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:45:17 -0500
Message-ID: <479833FA.2000208@goop.org>
Date: Wed, 23 Jan 2008 22:45:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       linux-mm@kvack.org, daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <4797384B.7080200@redhat.com> <20080123154130.GC7141@v2.random> <47977DCA.3040904@redhat.com>
In-Reply-To: <47977DCA.3040904@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Another maybe workable approach for Xen is to go through pv_ops
> (although pte_clear doesn't go through pv_ops right now, so this would
> be an additional hook too ...).
>   

It does for 32-bit PAE.  Making pte_clear uniform across all pagetable 
modes would be a nice cleanup.

    J
