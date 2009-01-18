Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbZARLpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbZARLpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 06:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765117AbZARLpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 06:45:23 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64083 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762818AbZARLpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 06:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=Q3Nrbgsxx/B5N+JBLI9r8G5FwJC1rKsLyj8gIPBBDoo5rMbrgexVsSOHgn1yWDzsWl
         nu5LbSMsDeW9UN+xOfl/XdIv8XXZHjS4dr6pUjoVS4dT+bfFFtXJ8D58NtFfgR/Rq6gs
         0M2VEKmR7E1b3bMnJ7X6dC49hPYicL1KvVLrM=
MIME-Version: 1.0
Date: Sun, 18 Jan 2009 11:45:18 +0000
X-Google-Sender-Auth: 14123321d4d266c9
Message-ID: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com>
Subject: 2.6.29-rc2 regression: hibernation hang on eeepc-701 (method 
	"platform" only)
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hibernation hangs just after writing the image.  With s2disk I can see
this from the console messages.  The same hang happens with kernel
swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
the image has been written from the HDD led.

In either case, I can still hard-power-off and resume from hibernation.

It doesn't hang if I use the shutdown method (either 'echo shutdown |
sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').

Let me know if you'd like more information.

Thanks
Alan
