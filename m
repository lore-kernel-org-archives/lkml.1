Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbZFBCf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbZFBCf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 22:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZFBCfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 22:35:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbZFBCfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 22:35:51 -0400
Message-ID: <4A24905A.5040500@cn.fujitsu.com>
Date: Tue, 02 Jun 2009 10:37:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] TOMOYO: Clarify lock protected section.
References: <200906020143.n521hGGP003698@www262.sakura.ne.jp> <4A248C90.9010904@cn.fujitsu.com> <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
In-Reply-To: <200906020230.n522UjfJ013581@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Li Zefan wrote:
>> Tetsuo Handa wrote:
>>> Enclose reader section in
>>> 	/***** READER SECTION START *****/
>>> and
>>> 	/***** READER SECTION END *****/
>>> and writer section in
>>> 	/***** WRITER SECTION START *****/
>>> and
>>> 	/***** WRITER SECTION END *****/
>>> in order to avoid oversighting lock protected section.
>>>
>> This makes me a bit uncomfortable..
>>
>> IMHO this seems ugly, useless, and even harmful. If it's helpful,
>> we'd be doing this for the whole kernel tree, which is crazy..
>>
>> Or does tomoyo do this for it's special reason?
> 
> I intended to help reviewers to visualize the range of protected section
> at a glance. But if reviewers feel noisy, I can remove these markers.
> 

I don't think it help review, but instead those '*'+UPPERCASE comments
are disturbing.



