Return-Path: <linux-kernel-owner+w=401wt.eu-S1161006AbXAaUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbXAaUAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161005AbXAaUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:00:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53695 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161006AbXAaUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qNgcyhJp0grvQS8+Hrw0MSfvkMkl0KW2h+bVelXN5ivnsiwfPximxtvRVBVCFqYYDMDp44ECxXbT0uz4no+tnXCtH9Ek52ukyTlPYSEHcXm6EYW12YmkbK6BKUn7CWVRBMZxGc8UuXY1bnMy0bh91ey/5S55xR0cMBvZKurJFJU=
Message-ID: <5157576d0701311200l355c2dd3n5b7b5d9ce915dbbd@mail.gmail.com>
Date: Wed, 31 Jan 2007 23:00:48 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: torvalds@linux-foundation.org, akpm@osdl.org
Subject: Fwd: 2.6.20-rc6 regression: kernel output redirected to console
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5157576d0701280149o5cbb72eelb2979680a174df74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5157576d0701280149o5cbb72eelb2979680a174df74@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've test 2.6.20-rc7,
still messages that ordinary catch syslog-ng, also go
to console, unlike 2.6.18(my default kernel) and 2.6.20-rc4(or rc3).

---------- Forwarded message ----------
From: Tomasz Kvarsin <kvarsin@gmail.com>
Date: Jan 28, 2007 12:49 PM
Subject: 2.6.20-rc6 regression: kernel output redirected to console
To: linux-kernel@vger.kernel.org


When I booted last time with 2.6.20(as I remember -rc4),
I don't see this issue:
all kernel message instead of just
go to syslog-ng and then into /var/log/messages
also go to console.
