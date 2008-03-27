Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYC0O7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYC0O7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYC0O7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:59:12 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:54425
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYC0O7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:59:11 -0400
Message-ID: <47EBB63E.2060306@qumranet.com>
Date: Thu, 27 Mar 2008 16:59:10 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [kvm-devel] kvm causing memory corruption?  ~2.6.25-rc6
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com> <1206629709.7883.30.camel@nimitz.home.sr71.net>
In-Reply-To: <1206629709.7883.30.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-03-27 at 12:10 +0200, Avi Kivity wrote:
>   
>> btw, is this with >= 4GB RAM on the host?
>>     
>
> Well, are you asking whether I have PAE on or not? :)
>
>   

No, I'm asking whether there is a possibility of address truncation :)

PAE by itself doesn't affect kvm much, as it always runs the guest in 
pae mode.

Can you try running with mem=2000M or something?

-- 
error compiling committee.c: too many arguments to function

