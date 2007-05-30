Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbXE3B7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbXE3B7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbXE3B7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:59:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13376 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXE3B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eTbiavyDbRVzkrEu1HBl9px5wJcBDrFu8MtUFC1PIiGVQIrkuQhZEHzvVqLrtqRhxSHx7bee1wITkdKLmhw/fleYP7mi1RYMoF2UXkysLdW2zPIuztGCGNUvQp+CFsrtYg8wZGXqY+J+E1b25ZdvbynPegR2cpmcgtQgNlbtOMM=
Message-ID: <86802c440705291859y39a4ca27uf5ddb84810f33510@mail.gmail.com>
Date: Tue, 29 May 2007 18:59:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, aacraid@adaptec.com
Subject: kexec and aacraid broken
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

latest tree, can not use kexec to load 2.6.22-rc3 at least.

got:

AAC0: adapter kernel panic'd fffffffd
AAC0: adapter kernel failed to start, init status=0


but can load 2.6.21.3


YH
