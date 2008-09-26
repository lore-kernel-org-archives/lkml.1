Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYIZK4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYIZK4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYIZK4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:56:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:57675 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYIZK4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jVRR8Pk3pJPrSR3l1SU0mvIK/GxlZvZ2f+pRuI+rUleHwk91nMF8SiKuDw4BhEzAfm
         vmWT8HvX6AkS9nDNKpiwbK9kO2OfIWG0hWw6p25EaUAVRZdpghShZ6o5WCUBhOCTpuMv
         eyem/G62fMniKu2L2/2rG/13LhtLpbiwfp1X4=
Message-ID: <e8ca35370809260356l569f248dya77c8a3d9586c21c@mail.gmail.com>
Date: Fri, 26 Sep 2008 12:56:21 +0200
From: "Pascal Terjan" <pterjan@gmail.com>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: Turning off camera also kills card reader on EeePC 900
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Corentin Chary" <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
In-Reply-To: <579556.5870.qm@web38203.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <579556.5870.qm@web38203.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:49 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
>> wrote:
>> > Sitsofe Wheeler wrote:
>> > The "HC died" message is interesting.  Sounds like the controller for
>> > these two USB devices stops working.  Maybe try unloading and reloading
>> > the ehci module?  I don't think I can help any more though.
>>
>> The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
>> kernel not in the hardware
>>
> [snip]
>>
>> So it looks like an ehci_hcd issue when the camera is disabled
>
>
> And of course, having tried Ingo Molnar's linux-tip (whereas before I was using 2.6.27) I have now found a modern kernel that doesn't exhibit the problem...
>

I have just tried with latest git and it seems to work fine !
