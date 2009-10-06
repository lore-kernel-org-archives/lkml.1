Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZJFGhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZJFGhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZJFGhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:37:51 -0400
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137]:18155 "EHLO
	nschwmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219AbZJFGhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:37:51 -0400
Message-ID: <4ACAE592.8030307@bigpond.net.au>
Date: Tue, 06 Oct 2009 16:37:06 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, Zhao Yakui <yakui.zhao@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [ERROR] drm:edid;  Unexpected error messages in syslog
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx03p.mx.bigpond.com from [58.165.86.228] using ID pwil3058@bigpond.net.au at Tue, 6 Oct 2009 06:37:07 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4ACAE593.0104,ss=1,fgs=0
X-SIH-MSG-ID: oxEyEt3+TECznTh522DtQVUtlUy7/yU1v8pWRYIhuR8QUkfFvN/WRdShcatRpcuzxEEfcgqVOHEgZabnWoXRtcmyIbxYYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've started getting the following messages on recent kernels:

Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:50:40 mudlark kernel:
Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:50:40 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:50:40 mudlark kernel:
Oct  5 16:50:40 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:50:41 mudlark kernel: [drm] DAC-6: set mode 1600x1200 16
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:50:45 mudlark kernel:
Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:50:45 mudlark kernel:
Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:50:45 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:50:45 mudlark kernel:
Oct  5 16:50:45 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:51:00 mudlark kernel:
Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:51:00 mudlark kernel:
Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* EDID 
checksum is invalid, remainder is 16
Oct  5 16:51:00 mudlark kernel: [drm:edid_is_valid] *ERROR* Raw EDID:
Oct  5 16:51:00 mudlark kernel:
Oct  5 16:51:00 mudlark kernel: i915 0000:00:02.0: VGA-1: EDID invalid.

Should I worry about these?  There's no other noticeable problem with 
the system.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
