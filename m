Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXAZUum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXAZUum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXAZUum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:50:42 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:30667 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbXAZUuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:50:40 -0500
Message-ID: <45BA6999.4000807@cfl.rr.com>
Date: Fri, 26 Jan 2007 15:50:33 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Khai Doan <khai@genius.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to create a fixed length character/block device/file ?
References: <45BA6018.5040406@genius.com>
In-Reply-To: <45BA6018.5040406@genius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 20:50:53.0767 (UTC) FILETIME=[AB8BBD70:01C7418B]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14960.000
X-TM-AS-Result: No--11.850300-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Khai Doan wrote:
> Sorry if this is the wrong list.  I've search google, but have not found 
> solution to my problem.
> 
> I have a long running application which split out lots of debugging 
> information.  I can't redirect the output to a regular file because that 
> file would grow and eat up all the diskspace.  I can't redirect to 
> /dev/null.  What I want is the last 1MB of the output before my 
> application terminated.  So I need to create a special file / device on 
> the system.  Please tell me if  there is an existing device that I can 
> use, or point me in the right direction so that I can role my own device.

myapp | tail -c1048576 > logfile

