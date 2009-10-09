Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbZJIBPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbZJIBPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbZJIBPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:15:50 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:54763 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbZJIBPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iWIRYbqNcoWOSzelnMQzUrOZ8evxnl0F/pAnsp5Vt/ybnj7/RGRw8VNSB0iKMrR3nv
         EZAX4gMUJ1nEuAMkQDjDVRyQnai/HzRaZbxsW/kkfmNrytVvEUKr2BrG3VuYpW/vpstD
         RWODC9o+wndiBqFXBT83klLxn+INSidfwDnVk=
Message-ID: <4ACE8E9D.2040009@gmail.com>
Date: Thu, 08 Oct 2009 19:15:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andreas <andreas2@logic.univie.ac.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: Allocated Mem - 700MB missing
References: <20091008175939.GA31126@logic.univie.ac.at>
In-Reply-To: <20091008175939.GA31126@logic.univie.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2009 11:59 AM, Andreas wrote:
> Hi experts!
>
> Where are the missing 700MB ???		(4GB installed)
> 700 MB is too much, that can't be only because of version-differences!
>
> I compared (unmodified) stable/testing kernels with Xen and OpenVZ-kernel:
> all out of main debian packages:
>
> Only3200:
> ----------
> *Linux host 2.6.18-5-686 #1 SMP Mon Dec 24 16:41:07 UTC 2007 i686 GNU/Linux
> *Linux knoppix 2.6.24.4 #2 SMP PREEMPT Tue Mar 25 21:35:28 CET 2008 i686 GNU/Linux
> *Linux host 2.6.26-2-686 #1 SMP Sun Jun 21 04:57:38 UTC 2009 i686 GNU/Linux
>
>
> Full4GB:
> ---------
> *Linux host 2.6.26-2-openvz-686 #1 SMP Sun Jun 21 07:07:25 UTC 2009 i686 GNU/Linux

Check the kernel configuration. For 32-bit kernels you need 
CONFIG_HIGHMEM64G enabled to use memory above 4GB (including in your 
case, because of the PCI, etc. memory holes). Though it would be better 
to use a 64-bit kernel.
