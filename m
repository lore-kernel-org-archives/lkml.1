Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbXDJVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbXDJVnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXDJVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:43:09 -0400
Received: from mabruk.micah.cowan.name ([66.150.225.51]:45753 "EHLO
	mabruk.micah.cowan.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXDJVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:43:07 -0400
Message-ID: <461C04E5.4090809@cowan.name>
Date: Tue, 10 Apr 2007 14:43:01 -0700
From: Micah Cowan <micah@cowan.name>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Use of SIGXFSZ outside of soft limits
References: <461BF183.10007@cowan.name> <20070410223829.23bc3d36@the-village.bc.nu>
In-Reply-To: <20070410223829.23bc3d36@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> [XSI] [Option Start] If the request would cause the file size to exceed 
>> the soft file size limit for the process and there is no room for any 
>> bytes to be written, the request shall fail and the implementation shall 
>> generate the SIGXFSZ signal for the thread. [Option End]
>>  >>>
> 
> This all depends which document and version you review. AIX for example
> has or had the same behaviour as Linux which comes from the Large File
> Summit and indeed our implementation was carefully tested to pass the
> test suite of the time.
> 
> SUSv3 seems to subsume the older LFS standards, and has adjusted them
> somewhat in the merging so there may well be a good case for normalizing
> our behaviour to match SUSv3. Run some tests and send patches.
> 
> Alan

Thanks very much for this response, Alan.

I kind of suspected it might be something like this. I'm relieved to 
know that the original reasons for signaling that on other cases may no 
longer apply.

I'll plan to be back with patches, then! :)

-Micah
