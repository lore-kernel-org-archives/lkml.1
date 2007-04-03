Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXDCTTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXDCTTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXDCTTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:19:21 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:1811 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbXDCTTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:19:20 -0400
Message-ID: <4612A8C5.1080103@cfl.rr.com>
Date: Tue, 03 Apr 2007 15:19:33 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ameya Mitragotri <ameya.mitragotri@gmail.com>
CC: linux-kernel@vger.kernel.org, suparna@in.ibm.com, pbadari@gmail.com
Subject: Re: fadvise+sync_file_range Vs O_DIRECT
References: <88df6dda0704030351u44fab6bcj20f9b48d24de861a@mail.gmail.com>
In-Reply-To: <88df6dda0704030351u44fab6bcj20f9b48d24de861a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 19:19:33.0260 (UTC) FILETIME=[0295FCC0:01C77625]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15094.000
X-TM-AS-Result: No--7.676800-5.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ameya Mitragotri wrote:
> Hello,
> I am doing some benchmarking on writes to the hdd from a simple
> application (attached).
> Im benchmarking the writes using the following
> - write with O_DIRECT
> - write with fadvise + O_SYNC
> - write with fadvise + sync_file_range

Did you use overlapped aio with O_DIRECT or just send down one request 
at a time?

