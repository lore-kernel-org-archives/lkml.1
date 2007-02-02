Return-Path: <linux-kernel-owner+w=401wt.eu-S1161141AbXBBQMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141AbXBBQMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161150AbXBBQMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:12:45 -0500
Received: from main.gmane.org ([80.91.229.2]:41493 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161141AbXBBQMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:12:44 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
 release.
Date: Fri, 02 Feb 2007 11:12:02 -0500
Message-ID: <45C362D2.2040407@tmr.com>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: libc-alpha@sources.redhat.com
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku wrote:
> Evgeniy Polyakov wrote:
>> I described in details why and how M:N model better, and its drawbacks
>> include all issues mentioned by Ulrich Drepper, but nevertheless its
>> advantages are far too superiour than those which can be
>> provided by 1:1
>> model.
> 
> M:N threading is an unnecessary performance hack that's needed by people
> who are living in a C or C++ exile away from some language that has
> lexical closures, generators or first-class continuations.

Yes, that's called the "real world." Arguments of the "I don't need it, 
in a perfect world you wouldn't either, therefore it's a bad idea" type 
simply contribute nothing.

Because user threading can avoid context switches, there will always be 
cases where it will outperform o/s threads for hardware reasons.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

