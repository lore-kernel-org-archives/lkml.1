Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXDDOX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXDDOX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXDDOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:23:58 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:16904 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753870AbXDDOX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:23:57 -0400
Message-ID: <4613B509.8050902@cfl.rr.com>
Date: Wed, 04 Apr 2007 10:24:09 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ameya Mitragotri <ameya.mitragotri@gmail.com>
CC: linux-kernel@vger.kernel.org, suparna@in.ibm.com, pbadari@gmail.com
Subject: Re: fadvise+sync_file_range Vs O_DIRECT
References: <88df6dda0704030351u44fab6bcj20f9b48d24de861a@mail.gmail.com>  <4612A8C5.1080103@cfl.rr.com> <88df6dda0704040342q3f8988a3idac7d88e51b9b181@mail.gmail.com>
In-Reply-To: <88df6dda0704040342q3f8988a3idac7d88e51b9b181@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2007 14:24:05.0468 (UTC) FILETIME=[E66959C0:01C776C4]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15096.000
X-TM-AS-Result: No--5.105800-5.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ameya Mitragotri wrote:
>> Did you use overlapped aio with O_DIRECT or just send down one request
>> at a time?
> 
> The app sends the requests one at a time

For best results, you need to send down several requests at once so the 
pipeline does not stall in between requests.


