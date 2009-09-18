Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZIRLgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZIRLgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZIRLgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:36:35 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:42318 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZIRLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <4AB36C9E.30902@nokia.com>
References: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
	 <4AB36C9E.30902@nokia.com>
Date: Fri, 18 Sep 2009 14:36:38 +0300
Message-ID: <cc557aab0909180436t845d9eanbac568977dff4947@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 2:18 PM, Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> What's the "insn" here?? And even if no IFAR is implemented, there should be
> IFSR. For NOMMU there should be pabort_noifsr simply returning zero values,
> similar to data abort handler.

No, both IFAR and IFSR is only implemented in ARMv7 so we have to handle
it together, I think.
