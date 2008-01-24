Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYAXGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYAXGIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYAXGIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:08:09 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:46762
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYAXGII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:08:08 -0500
Message-ID: <479829AD.9000807@qumranet.com>
Date: Thu, 24 Jan 2008 08:01:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
References: <478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random> <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com> <4797384B.7080200@redhat.com> <20080123154130.GC7141@v2.random> <47977DCA.3040904@redhat.com>
In-Reply-To: <47977DCA.3040904@redhat.com>
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

I think that's the way.  Xen is not a secondary mmu but rather a primary 
mmu with some magic characteristics.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

