Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZLJQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZLJQO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZLJQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:14:58 -0500
Received: from bzq-179-83-110.static.bezeqint.net ([212.179.83.110]:51589 "EHLO
	imaginecommunications.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751450AbZLJQO5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:14:57 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 11:14:56 EST
From: Jacob Avraham <jacob@imaginecommunications.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Dec 2009 18:09:17 +0200
Subject: kernel memory allocation limit
Thread-Topic: kernel memory allocation limit
Thread-Index: Acp5sx/thvgNTegdTx+N01W7s5yROg==
Message-ID: <FF584854D6FFE547AB2F7515A798AC3A0AF9C98A66@venus.imagineil.tv>
Accept-Language: en-US, he-IL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {CF3192AC-8BB6-4CE7-A537-2ED6FF555ACE}
x-cr-hashedpuzzle: Ae1I Ay5y BQKR CRbz C5TQ C9G8 EhGu Fefa Gfqa Hnb5 H5A+
	KGv7 Kp89 K/MX LU05
	LX2l;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{CF3192AC-8BB6-4CE7-A537-2ED6FF555ACE};agBhAGMAbwBiAEAAaQBtAGEAZwBpAG4AZQBjAG8AbQBtAHUAbgBpAGMAYQB0AGkAbwBuAHMALgBjAG8AbQA=;Thu,
	10 Dec 2009 16:09:17
	GMT;awBlAHIAbgBlAGwAIABtAGUAbQBvAHIAeQAgAGEAbABsAG8AYwBhAHQAaQBvAG4AIABsAGkAbQBpAHQA
acceptlanguage: en-US, he-IL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to allocation in my module a bunch of contiguous memory segments using __get_free_pages(), 128k at a time, from the NORMAL zone on a x86-64 machine with 24G ram. Kernel is 2.6.18 from CentOS5.3. I ran into a hard limit of 2G.
Where is this limitation coming from and is it changeable?

Thanks,
Jacob Avraham


 
 
************************************************************************************
This footnote confirms that this email message has been scanned by
PineApp Mail-SeCure for the presence of malicious code, vandals & computer viruses.
************************************************************************************



