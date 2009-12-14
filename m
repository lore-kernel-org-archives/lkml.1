Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZLNMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZLNMuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZLNMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:50:39 -0500
Received: from mail.turknet.net.tr ([193.192.98.182]:57049 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZLNMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:50:39 -0500
Message-ID: <4B26349D.1080904@netone.com.tr>
Date: Mon, 14 Dec 2009 14:50:37 +0200
From: Tarkan Erimer <tarkane@netone.com.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-12.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux-2.6.32-git10 drm_i915 error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2009 12:50:37.0856 (UTC) FILETIME=[08E76A00:01CA7CBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequently, I hit this bug on Linux-2.6.32-git10. It's always
re-producible for me on my i945 video device equipped HP machine. When
hit this bug, it crashes the X server and screen goes black. But,
possible to switch to console. Here is the error log, I had in dmesg:

[ 2596.328132] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[ 2596.328146] render error detected, EIR: 0x00000000
[ 2596.328167] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
returns -5 (awaiting 694588 at 694584)
[ 2596.439006] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[ 2596.439013] render error detected, EIR: 0x00000000

Tarkan
