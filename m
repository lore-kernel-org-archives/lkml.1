Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZKMR6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZKMR6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZKMR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:58:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43112 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZKMR6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:58:17 -0500
Message-ID: <4AFD9E3A.6070801@canonical.com>
Date: Fri, 13 Nov 2009 09:58:18 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #3 0/12] AppArmor security module
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com> <20091113094425.5b4c553b@s6510>
In-Reply-To: <20091113094425.5b4c553b@s6510>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Tue, 10 Nov 2009 08:12:53 -0800
> John Johansen <john.johansen@canonical.com> wrote:
> 
>> This is the newest version of the AppArmor security module it has been
>> rewritten to use the security_path hooks instead of the previous vfs
>> approach.  The current implementation is aimed at being as semantically
>> close to previous versions of AppArmor as possible while using the
>> existing LSM infrastructure.
> 
> Does it fix the problem reported as the #1 failure on kernel oops:
> 
> Oops 718946 first showed up in kernel version 2.6.31-14-generic
> Oops 718946 last showed up in version 2.6.31-13-generic
> 2.6.31 -- 512

yes, and several others oops as well.  I have also identified a couple other
oops that will have fixes in push #4.

thanks
john
