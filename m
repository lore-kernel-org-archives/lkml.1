Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbZAPIBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbZAPIBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZAPIB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:01:27 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:48567 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZAPIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:01:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=n2cRLnD+iHpHlQxV4ZlC76zMCZbxQ8kfMd6hapc4Y/pJ/yTCu1zYxZSGV26C+5lMh6
         TQgQ6o5PwZsiEuQPYcaTAiQODR6kwwgtY3CIhdFE54iWqaPImK/flpunMH45xvJt902z
         h0KCFdqFuiW0IIcrytSeEFZiZHSouXa2W+Qi8=
Message-ID: <49703ED2.8010606@gmail.com>
Date: Fri, 16 Jan 2009 00:01:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: conflicting memory types 40000000-48000000 write-combining<->uncached-minus
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is probably an Xorg issue,
but you never know);
noticed this when doing a git-pull
a few day's ago:

[   31.816030] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   32.224553] [drm] Setting GART location based on new memory map
[   32.225952] [drm] Loading R500 Microcode
[   32.226010] [drm] Num pipes: 1
[   32.226024] [drm] writeback test succeeded in 1 usecs
[   32.611979] Xorg:2661 conflicting memory types 40000000-48000000 
write-combining<->uncached-minus
[   32.611983] reserve_memtype failed 0x40000000-0x48000000, track 
write-combining, req write-combining
[   32.968560] Xorg:2661 conflicting memory types 40000000-48000000 
write-combining<->uncached-minus
[   32.968565] reserve_memtype failed 0x40000000-0x48000000, track 
write-combining, req write-combining

should I be concerned, or no?

regards;

Justin P. Mattock
