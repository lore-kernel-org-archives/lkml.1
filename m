Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYEBAGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYEBAGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYEBAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:05:55 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:43602 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754559AbYEBAFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:05:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=RQWhD8K5CTSkFAfjUeA3mtNU2XcXk4eqQbWth7fSHX3mYldIAekNnTmQ1WMxW3SZaKJNWJ36MNtxMHBZiQq0bpVFwypiz9LawRJl6OXA2hmMOk9FAHlFwxklOXuWM3lLfQI4WFUmA+RbhcRcXrhYnz8m+lxI63zs9Y6p7cDS49E=  ;
X-YMail-OSG: 0NIr.nIVM1ngvGwRjO4qBlbE_Ug_8W5JA4_oqy4KqnsVQH.f95QNPEdr2mDHDEThWF3xJIEsIs4n9d3TF_L6ieOoaHL0WDWpOO5ht1SnFWHwRrnTFrQdOlL6hc0O28KSQyo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <481A5A94.2080400@sbcglobal.net>
Date: Thu, 01 May 2008 17:04:36 -0700
From: Ryan Roth <ryanroth@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ryan.Roth@CH2M.com, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting
 With 2.6.24.5 Kernel
References: <bug-10586-10286@http.bugzilla.kernel.org/>	<20080501130444.cc5c63e8.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>	<20080501133003.be723364.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>	<481A5276.4040607@sbcglobal.net> <20080501170239.9b740877.akpm@linux-foundation.org>
In-Reply-To: <20080501170239.9b740877.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 May 2008 16:29:58 -0700
> Ryan Roth <ryanroth@sbcglobal.net> wrote:
>
>   
>>> OK, worried.  This is a huge bug.  But afaik you're the only person 
>>> who has
>>> hit it, so there must be something special in your setup which is
>>> triggering it.  This could be hard.
>>>
>>>       
>> OK here is what I get with the git16 kernel.  On boot I get this error:
>>
>> PCI: Not using MMCONFIG
>> PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard 
>> resources
>> PCI: Not using MMCONFIG
>>     
>
> yeah, mmconfig is a problem.  It should be harmless.  Probably you're
> better off with it disabled ;)
>
>   
>> Attached is a complete log after this boot
>>     
>
> I see no 'segfault' messages in there?
>
>   
Since this last boot I have only got these:

> May 1 16:26:25 kernel: gnome-power-man[3112]: segfault at 0 ip 410fda 
> sp 7fff4712c870 error 4 in gnome-power-manager[400000+47000]
> May 1 16:26:25 kernel: gnome-power-man[3116]: segfault at 0 ip 410fda 
> sp 7fff2959cce0 error 4 in gnome-power-manager[400000+47000]
> May 1 16:26:25 kernel: gnome-power-man[3119]: segfault at 0 ip 410fda 
> sp 7fffc7671db0 error 4 in gnome-power-manager[400000+47000]

