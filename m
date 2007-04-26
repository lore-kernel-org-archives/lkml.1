Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXDZTOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXDZTOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXDZTOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:14:52 -0400
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:41142
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1031462AbXDZTOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:14:49 -0400
Message-ID: <4630FA27.1090203@seclark.us>
Date: Thu, 26 Apr 2007 15:14:47 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <4630E00B.3090502@tmr.com> <4630E9C8.5060000@garzik.org>
In-Reply-To: <4630E9C8.5060000@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>IMO, the closer you look, the more warts you find.  Before you starting 
>doing your work with kernel regressions, no one was really tracking it. 
>  I bet you have helped cut down on the regressions, but I have no good 
>way to quantify my gut feeling.
>
>Additional comments on developers and fixing regressions:
>
>* Sometimes seeing a long list, peoples' eyes glaze over.  Its just 
>human nature.  A long list also gives us no idea of scale, or severity. 
>  I bet a weekly "top 10 bugs and regressions" email would help focus 
>developer attention.
>
>* To be effective, lists, either long or top-10, must be pruned if you 
>get a sense that only one user is affected.  [With oopses and BUGs as a 
>clear exception,] many problems benefit from at least two users 
>reporting a bug.
>
>* It gets a bit tiresome to field the large number of driver bug reports 
>that eventually turn out to be related to broken interrupt handling 
>somehow.  I think we developers need to get better at showing users how 
>to isolate driver vs. PCI/ACPI/core bugs.  Maybe drivers need to start 
>introducing interrupt delivery tests into their probe code.  Overall, 
>broken interrupt handling manifests in several ways, most of which 
>initially appear symptomatic of a broken driver.
>
>	Jeff
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
Jeff,

If hardware worked in the previous version of the kernel can't users expect
 the same hardware to work in this kernel?

Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



