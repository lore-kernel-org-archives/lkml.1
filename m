Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbZIWEOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbZIWEOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZIWEOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:14:55 -0400
Received: from mail.crca.org.au ([67.207.131.56]:46004 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZIWEOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:14:54 -0400
X-Bogosity: Ham, spamicity=0.000798
Message-ID: <4AB9A0D6.1090004@crca.org.au>
Date: Wed, 23 Sep 2009 14:15:18 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: No more bits in vm_area_struct's vm_flags.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

With the addition of the VM_MERGEABLE flag to vm_flags post-2.6.31, the
last bit in vm_flags has been used.

I have some code in TuxOnIce that needs a bit too (explicitly mark the
VMA as needing to be atomically copied, for GEM objects), and am not
sure what the canonical way to proceed is. Should a new unsigned long be
added? The difficulty I see with that is that my flag was used in
shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
function would need an extra parameter too..

Regards,

Nigel
