Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0CLVxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:53:21 -0500
Received: from claw.goop.org ([74.207.240.146]:51460 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0CLVxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:53:19 -0500
Message-ID: <4B9AB7CE.5090601@goop.org>
Date: Fri, 12 Mar 2010 13:53:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>	<201003121123.33935.sheng@linux.intel.com> <alpine.DEB.2.00.1003121024590.27222@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1003121024590.27222@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 02:42 AM, Stefano Stabellini wrote:
> On Fri, 12 Mar 2010, Sheng Yang wrote:
>    
>> On Wednesday 10 March 2010 23:46:54 Stefano Stabellini wrote:
>>      
>>> Hi all,
>>>        
>> Stefano,
>>
>> And next time when you send out the patch, please be more respect to my work.
>>
>> You dropped all the original author(me) of patchset, and only add a sign-off
>> for me. If you don't aware the difference, here is a snippet of
>> linux/Documentation/SummittingPatches
>>
>>      
> I am truly sorry and apologise for it, I would never want to give you
> the impression of being disrespectful of you and your work.
> If you pay attention I manually wrote in the comments of all the past
> versions of the patches that you were the original author, this time I
> just forgot.
> I guess it is really the time I start using git-send-email :)
>
> Your work has been really important for my series and you deserve the
> credit for it independently from which patch series gets applied.
>    

Best practise for this kind of thing is to use Sheng's patch verbatim, 
then apply a separate delta on top to make the changes you want.  That way:

    * credit can be property attributed
    * it helps with maintaining two parallel-but-converging git
      branches, because all the common stuff is genuinely common, and
      the variations can work from there, and
    * if Sheng updates his patches (review, bugfix, etc), then we can
      easily see how those changes affect your changes.

For example, I just rebased your previous patch posting so that it is 
rooted on Sheng's two base patches, as they're completely common.

The latest of both patches is in xen/pvhvm-sheng and -stefano.

     J
