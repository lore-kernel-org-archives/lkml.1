Return-Path: <linux-kernel-owner+w=401wt.eu-S1767228AbXCIMuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767228AbXCIMuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767230AbXCIMuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:50:11 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:12148 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767227AbXCIMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Lc6P12bRbV8U2WXTnsNhwqnV09NvsuolMWVRhBp2r3bmt1kB5SHHDIARRy3iR1yN97GxxwrEqPnZ3TVhZ6z4V6RMM4ePbQXO6THwRre+i137jC3zAnnX+Y0VysFWeGEFaxaPwiBvcdhKqAZ/aomPbLChy9rHCLKyxMeIlKrmbVU=
Message-ID: <45F157FF.50801@gmail.com>
Date: Fri, 09 Mar 2007 21:50:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATA] Failed to set xfermode on LITE-ON LTR-48246S
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070227135838.GA4328@titan.lahn.de> <45EB9822.40300@gmail.com> <20070305103840.GA4381@titan.lahn.de> <45EC3B3F.7020509@gmail.com> <20070306092339.GA3803@titan.lahn.de>
In-Reply-To: <20070306092339.GA3803@titan.lahn.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Matthias Hahn wrote:
> Hello Tejun!
> 
> On Tue, Mar 06, 2007 at 12:46:07AM +0900, Tejun Heo wrote:
>> Philipp Matthias Hahn wrote:
>>> On Mon, Mar 05, 2007 at 01:10:10PM +0900, Tejun Heo wrote:
>>>> * Does applying the attached patch over unpatched 2.6.20.1 fix the problem?
>>> Yes, it seems to fix it. (testes on top of the first patch mentioned
>>> above, but witheout the second one.).
>>> If I should test it as the sole patche, just mail me again please.
>> Yeap, please test it on top of vanilla kernel to verify that the patch
>> proper fixes the problem.
> 
> Yes, applying only this patch does fix the problem.
> Thank you for your support.

Okay, it seems we'll have to default to polling SETXFER.  I'll forward
it upstream soon.  Thanks.

-- 
tejun
