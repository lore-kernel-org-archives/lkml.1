Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYH0A1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYH0A1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYH0A1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:27:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:34724 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYH0A1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=a2D2nHeQMcBgYPbcQgjWdvzpc5wVwpsgWh9htjk4uCesMHFsvcHFAMlSixaW/PPf3V
         EXlQ+EjR5vTsYL6HpExvZynbwLzkIRQutCOlC4Aqn/Rcf5vF+KbmBu5YGp2EtgPHIRZv
         BNpPSozMBt9iqSCEXHcfDFBL8ox81oYvG4ZpY=
Message-ID: <804dabb00808261727o3ba1f3c0xc25d27ad0694aab4@mail.gmail.com>
Date: Wed, 27 Aug 2008 08:27:32 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Locking API testsuite: Failures
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000999] | Locking API testsuite:
[    0.000999] ----------------------------------------------------------------------------
[    0.000999]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[    0.000999]
--------------------------------------------------------------------------
[    0.000999]                      A-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]                  A-B-B-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]              A-B-B-C-C-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]              A-B-C-A-B-C deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000999]                     double
unlock:failed|failed|failed|failed|failed|failed|
[    0.000999]                   initialize
held:failed|failed|failed|failed|failed|failed|
[    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000999]
--------------------------------------------------------------------------
[    0.000999]               recursive read-lock:             |  ok  |
            |failed|
[    0.000999]            recursive read-lock #2:             |  ok  |
            |failed|
[    0.000999]             mixed read-write-lock:             |failed|
            |failed|
[    0.000999]             mixed write-read-lock:             |failed|
            |failed|
[    0.000999]
--------------------------------------------------------------------------
[    0.000999]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000999]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000999]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000999]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000999]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000999]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |

truncated....

I am just curious what does all these failures imply?

thanks.

-- 
Regards,
Peter Teoh
