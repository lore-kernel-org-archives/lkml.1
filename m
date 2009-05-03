Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbZECTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbZECTip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZECTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:38:33 -0400
Received: from main.gmane.org ([80.91.229.2]:38712 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZECTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:38:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Specific support for Intel Atom architecture
Date: Sun, 03 May 2009 20:38:20 +0100
Message-ID: <yw1x4ow2ugcz.fsf@ps3.mansr.com>
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu> <49F9DB70.2050906@zytor.com> <20090503053821.GI570@1wt.eu> <20090503075346.63fc7211@infradead.org> <20090503183038.GA8571@1wt.eu> <49FDE47C.7090607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
Cancel-Lock: sha1:/xiYCPQSlHYLpXjzfjK6eU1oMCk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Willy Tarreau wrote:
>>>>>
>>>>> $(call cc-option,-march=atom,-march=i686)
>>>> if it's an in-order architecture, wouldn't it be better to tune for
>>>> i386 or i486 instead ?
>>> -march isn't about tuning, it's about supported instructions.
>> 
>> agreed, but unless specified otherwise using -mtune, -march also sets
>> default tuning for the indicated CPU. At least in my experience.
>> 
>>> The right line is
>>> $(call cc-option,-march=atom,-march=core2)
>
> For really old gcc's (we support all the way back to gcc 3.2 still)
> -march=core2 might not work either.

-march=core2 support was added in gcc 4.3.

-- 
Måns Rullgård
mans@mansr.com

