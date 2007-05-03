Return-Path: <linux-kernel-owner+w=401wt.eu-S1767706AbXECTH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767706AbXECTH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767709AbXECTHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:07:25 -0400
Received: from mail.aknet.ru ([82.179.72.26]:65504 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767707AbXECTHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:07:24 -0400
Message-ID: <463A338A.2010909@aknet.ru>
Date: Thu, 03 May 2007 23:10:02 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] export hrtimer_forward
References: <463A2296.7000804@aknet.ru> <1178218674.24217.14.camel@twins>
In-Reply-To: <1178218674.24217.14.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Peter Zijlstra wrote:
>> It seems hrtimer_forward was forgotten to
>> export - other symbols of the hrtimers API
> Are there actual in-tree users of this symbol? Without we usually leave
> the symbol unexported, this saves some space.
Do you mean it was really left intentional?
Unbeleivable! But why the other parts of a
hrtimer API are exported nevertheless, and
only this particular function not?

As for the users - I am porting my pcsp driver to
it and I need that function.
It is not exactly in-tree stuff, but it was
in an ALSA tree for years already, so it is a
close one.

