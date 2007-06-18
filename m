Return-Path: <linux-kernel-owner+w=401wt.eu-S1764478AbXFRR45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764478AbXFRR45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760566AbXFRR4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:56:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60470 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759273AbXFRR4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:56:48 -0400
In-Reply-To: <4676B4B9.9030002@hawkeye.stone.uk.eu.org>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: akpm@linux-foundation.org, alan <alan@clueserver.org>, hpa@zytor.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
MIME-Version: 1.0
Subject: Re: Versioning file system
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF7FA807A1.64C0D5AF-ON882572FE.0061B34C-882572FE.00628322@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Mon, 18 Jun 2007 10:56:05 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V80_M5_05202007|May 20, 2007) at
 06/18/2007 13:56:01,
	Serialize complete at 06/18/2007 13:56:01
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>The question remains is where to implement versioning: directly in
>individual filesystems or in the vfs code so all filesystems can use it?

Or not in the kernel at all.  I've been doing versioning of the types I 
described for years with user space code and I don't remember feeling that 
I compromised in order not to involve the kernel.

Of course, if you want to do it with snapshots and COW, you'll have to ask 
where in the kernel to put that, but that's not a file versioning 
question; it's the larger snapshot question.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems


