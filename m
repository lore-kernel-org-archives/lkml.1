Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZHMI63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZHMI63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZHMI62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:58:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZHMI61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:58:27 -0400
Message-ID: <4A83D5AC.1030503@redhat.com>
Date: Thu, 13 Aug 2009 11:58:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kvm tree build failure
References: <20090813125840.048af293.sfr@canb.auug.org.au>
In-Reply-To: <20090813125840.048af293.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 05:58 AM, Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next build (x86_64 allmodconfig) failed like this:
>
> x86_64-linux-gcc: arch/x86/kvm/x86_emulate.c: No such file or directory
>
> Caused by commit 5383e9982ee230b06b3c385e675ae6fc7846c40f ("KVM: Rename
> x86_emulate.c to emulate.c").
>
> I have used the version of the kvm tree from next-20090812 for today.
>    

Fixed now, don't know how such brokenness slipped out.

-- 
error compiling committee.c: too many arguments to function

