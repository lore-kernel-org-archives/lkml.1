Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZJRGoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZJRGoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 02:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZJRGoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 02:44:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZJRGoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 02:44:02 -0400
Message-ID: <4ADAB8F4.6090502@redhat.com>
Date: Sun, 18 Oct 2009 15:43:00 +0900
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com> <4AD6C679.3000001@redhat.com> <4AD77C21.2050506@goop.org>
In-Reply-To: <4AD77C21.2050506@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2009 04:46 AM, Jeremy Fitzhardinge wrote:
> Care to cook up a patch to implement the kvm bits to make sure it all
> works OK for you?
>    

I've started to do that, but it occurs to me that we're missing out on 
NUMA placement by forcing all clocks to be on the same page. OTOH, if 
the clocks are heavily used, they'll stay in cache, and if not, who cares.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

