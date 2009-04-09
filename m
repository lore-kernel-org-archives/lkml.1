Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbZDIObs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbZDIObs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933932AbZDIObc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:31:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:21308 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762698AbZDIOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=I/lsBH8fAeJ9IRmtYFmCIrnIuAO1PGkO94hFBCMAFMj9VnBRVxK2LDv/IuICDa0U9i
         PeRkPbCF4UK6vAEHRl2LIKr+n0JMUaLdS6RWg4AtoMlPbtZoKHAIdZOPai8DZLQQX2Rk
         wwgIeNxKp0tQ3yb+fXIBuFahPaqzxgT2PvTTA=
Date: Thu, 9 Apr 2009 10:31:12 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: subrata@linux.vnet.ibm.com, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       Greg KH <greg@kroah.com>, sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [BUILD FAILURE 04] Next April 9 : PPC64 randconfig
	[drivers/net/ibm_newemac/core.c]
Message-ID: <20090409143112.GA7538@yoda.jdub.homelinux.org>
References: <1239285152.5188.66.camel@subratamodak.linux.ibm.com> <BE92FB74-1784-414B-B27F-8329185EB3AE@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BE92FB74-1784-414B-B27F-8329185EB3AE@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 09:28:23AM -0500, Kumar Gala wrote:
>
> On Apr 9, 2009, at 8:52 AM, Subrata Modak wrote:
>
>> Observed the following build error:
>>
>> CC      drivers/net/ibm_newemac/core.o
>> drivers/net/ibm_newemac/core.c: In function ‘emac_probe’:
>> drivers/net/ibm_newemac/core.c:2831: error: ‘struct net_device’ has no
>> member named ‘open’
>> drivers/net/ibm_newemac/core.c:2834: error: ‘struct net_device’ has no
>> member named ‘tx_timeout’
>> drivers/net/ibm_newemac/core.c:2836: error: ‘struct net_device’ has no
>> member named ‘stop’
>> drivers/net/ibm_newemac/core.c:2837: error: ‘struct net_device’ has no
>> member named ‘get_stats’
>> drivers/net/ibm_newemac/core.c:2838: error: ‘struct net_device’ has no
>> member named ‘set_multicast_list’
>> drivers/net/ibm_newemac/core.c:2839: error: ‘struct net_device’ has no
>> member named ‘do_ioctl’
>> drivers/net/ibm_newemac/core.c:2841: error: ‘struct net_device’ has no
>> member named ‘hard_start_xmit’
>> drivers/net/ibm_newemac/core.c:2842: error: ‘struct net_device’ has no
>> member named ‘change_mtu’
>> drivers/net/ibm_newemac/core.c:2845: error: ‘struct net_device’ has no
>> member named ‘hard_start_xmit’
>> make[3]: *** [drivers/net/ibm_newemac/core.o] Error 1
>> make[2]: *** [drivers/net/ibm_newemac] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>>
>> Regards--
>> Subrata
>>
>> <randconfig4-ppc64-next20090409.txt>
>
> This is because CONFIG_COMPAT_NET_DEV_OPS isnt set and needs to be for  
> this driver to build.  I've asked the netdev guys about either fixing  
> the driver or adding the proper thing to Kconfig to select  
> CONFIG_COMPAT_NET_DEV_OPS.

Thanks!

If someone has pointers on what needs to be done to fix it, let me know.

josh
