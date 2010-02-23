Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0BWHpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:45:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55169 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0BWHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:45:09 -0500
Message-ID: <4B83877D.7030308@canonical.com>
Date: Mon, 22 Feb 2010 23:45:01 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 12/12] Kconfig and Makefiles to enable configuration and
 building of AppArmor.
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <1266572188-26529-13-git-send-email-john.johansen@canonical.com> <20100222221657.GB22194@us.ibm.com>
In-Reply-To: <20100222221657.GB22194@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting john.johansen@canonical.com (john.johansen@canonical.com):
>> From: John Johansen <john.johansen@canonical.com>
>>

<< snip >>

>> +config SECURITY_APPARMOR_NETWORK
>> +       bool "AppArmor network support"
>> +       depends on SECURITY_APPARMOR
>> +       default n
>> +       help
>> +	 This enables AppArmor to mediate applications network use.
>> +	 This will enable the SECURITY_NETWORK hooks.
> 
> Is there a compelling reason to have SECURITY_APPARMOR_NETWORK?   Does
> it impact performance?  Is there older userspace that will just break?
> 
No, not really anymore.  There used to be a case where I was building
with network hooks off and this has just been carried forward.

So it can go along with config APPARMOR_24_COMPAT, and I have even
been considering pulling the runtime disable as well as I don't
think there is a case for that either.
