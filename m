Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYIYVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYIYVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYIYVST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:18:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25825 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbYIYVSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:18:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=lVWSo5WCEsOkkGoNjJF/2sseNOIDdM6GVCEaaRU1Kwhc28eLksO989e1vfad3Dymms
         MImEl+ElRlBrVcygczG+5HJ0SgDJ69II7yYuCeZLcLXGEWl+yF3kluwNo4aTMpKyjyqB
         THFO+PL5Pyrls765SDxIAZ4FQhwLgUEq9CkQo=
Message-ID: <48DC00C9.9070106@tuffmail.co.uk>
Date: Thu, 25 Sep 2008 21:21:13 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@gmail.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <48CE217A.1080409@tuffmail.co.uk> <48CE52EC.9060505@yahoo.com>	 <48CE650B.6000708@tuffmail.co.uk> <e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com>
In-Reply-To: <e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:
>   
>> Sitsofe Wheeler wrote:
>> The "HC died" message is interesting.  Sounds like the controller for
>> these two USB devices stops working.  Maybe try unloading and reloading
>> the ehci module?  I don't think I can help any more though.
>>     
>
> The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
> kernel not in the hardware
>   
On the bright side, that means more people should have the hardware to 
test it on (including me :-).

I've certainly used the camera enable/disable at some point.  But I 
could have missed the error message, and frankly I don't use the camera 
or cardreader very often.  I'll have a bash at it tomorrow.

Sitsofe says it reproduced on kernel.org 2.6.21 (presumably with an 
out-of-tree eeepc module).  So I guess this isn't a simple git-bisect 
job - more thinking required...

Thanks
Alan
