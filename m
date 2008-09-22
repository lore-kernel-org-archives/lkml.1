Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYIVJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYIVJ50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYIVJ5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:57:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:50608 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYIVJ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HhMlVvRHULJxhjk/+XYz9y38gIz+UbvXNi3qO2hAvZDqOT7bASoCduBH2WXT+UV7gj
         GCd7vQ3FnG2hJ8MIC5DEVJr39PibQG3d3NrtSLK6U5xJrNd60/1ogO90lX2XCCZiRogT
         HvbQvBQ79pKfOSRsq1v1ZCpWss25vptbQYMBE=
Message-ID: <86802c440809220257q4e1b4c81o534c957d919a6b3c@mail.gmail.com>
Date: Mon, 22 Sep 2008 02:57:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080922095148.GD7663@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080922093603.GC7663@localhost> <20080922095148.GD7663@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Actually it's resend of the patch. On previous attempt
> Yinghai was proposed to choose:
>
>> one apic_version or boot_cpu_apic_version could be enough
>
> but I think it should be different patch which does cleaning
> up variables usage. So for now I think _this_ patch is enough
> since idea is to prevent of touching nonexistant register rather
> code cleaning (whci could be done later).

do we have systems that have mixed cpu supported with different apic version?

YH
