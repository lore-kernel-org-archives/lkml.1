Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYDDAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYDDAul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYDDAua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:50:30 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:39898 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYDDAu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:50:29 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Fri, 4 Apr 2008 03:49:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.HU.8DW9HB@albercik>
In-Reply-To: <pdYe6zNQVl.A.HU.8DW9HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040349.52702.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19AJrjVhTYraeKn374dpOhgBoD83mLYoRWyFJPJ
	jGXTaDf1Xlx0Q0GFdkQPdV3F6DI9s5ZNeBW6HQAhI6Ku5WFBgM
	3zfsIjNUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 01:22:44 Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
> Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
> Submitter	: Chr <chunkeey@web.de>
> Date		: 2008-03-30 21:09 (5 days old)
> References	: http://lkml.org/lkml/2008/3/30/87

Yep, it's still present... but I don't have no time to debug it. :(

Rhe proposed workaround: "noapictimer" and "hpet=force" works so far...
Maybe it's buggy/bad hardware after all and 2.6.24.4 just doesn't trigger it?! 

Regards,
	Chr.
