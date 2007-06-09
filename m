Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbXFITjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbXFITjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXFITjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:39:24 -0400
Received: from gw.ac.upc.edu ([147.83.30.3]:55021 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760062AbXFITjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:39:23 -0400
In-Reply-To: <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4> <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu> <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3740BDAB-1BA9-4744-ABB0-8812CF241402@ac.upc.edu>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
Date: Sat, 9 Jun 2007 21:39:19 +0200
To: Christian Kujau <christian@g-house.de>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2007, at 21:34, Christian Kujau wrote:

> On Sat, 9 Jun 2007, Julio M. Merino Vidal wrote:
>> Wouldn't this be better expressed as:
>>
>>   start=$(($start + 8))
>>   size=$(($end - $start))
>>
>> to avoid invoking a subshell?
>
> This is certainly possible for lots for scripts, but was not the  
> "scope" of this patch. ` is not bash-specific and does not break  
> anything.

$((...)) is not bash-specific either.

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


