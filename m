Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZLJCAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZLJCAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbZLJCAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:00:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbZLJCAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:00:04 -0500
Message-ID: <4B2054A6.6040502@zytor.com>
Date: Wed, 09 Dec 2009 17:53:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200912080317.08254.rob@landley.net> <200912091740.43147.rob@landley.net> <4B203691.7020203@zytor.com> <200912091950.58950.rob@landley.net>
In-Reply-To: <200912091950.58950.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 05:50 PM, Rob Landley wrote:
> On Wednesday 09 December 2009 17:45:21 H. Peter Anvin wrote:
>> On 12/09/2009 03:40 PM, Rob Landley wrote:
>>> This is why reducing the perl version to just the precomputed constants
>>> wouldn't work either.  (They're there so that you only need to install a
>>> random cpan library when surprised by a build break on non-x86 machines.)
>>
>> It's not "a random CPAN library" - it's a core module.
> 
> Then why cache large quantities of its output and test for its existence?
> 

To support archaic Perl versions and Perl binaries without libraries.

	-hpa

