Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZLWUCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZLWUCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZLWUCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:02:46 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:48280 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756946AbZLWUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:02:45 -0500
X-Spam-Virus: No
Message-ID: <4B32773F.8030508@mandriva.com>
Date: Wed, 23 Dec 2009 18:02:07 -0200
From: Eugeni Dodonov <eugeni@mandriva.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091211 Mandriva/3.0-4mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH: asus_oled oops in 2.6.32.2
References: <4B320CAA.1030708@mandriva.com> <20091223174941.GA20331@kroah.com>
In-Reply-To: <20091223174941.GA20331@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 03:49 PM, Greg KH wrote:
> On Wed, Dec 23, 2009 at 10:27:22AM -0200, Eugeni Dodonov wrote:
>> Hi,
>>
>> After updating to 2.6.32 kernel, I started experiencing Oopses caused by
>> the asus_oled module. After quick investigation, I wrapped this simple
>> patch which fixes an Oops in by asus_oled module on 2.6.32.2 kernel,
>> caused by incorrect usage of strict_strtoul function call within
>> set_enabled and set_disabled functions. This can be triggered by simple
>> running the userspace client for asus_old (e.g., 'asusoled -e' or
>> 'asusoled -d').
> 
> Looks good, can I get a 'Signed-off-by:' line so that I can apply the
> patch?

Sure:
Signed-off-by: Eugeni Dodonov <eugeni@mandriva.com>

Thanks,
Eugeni

-- 
Eugeni Dodonov
