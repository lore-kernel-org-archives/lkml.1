Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbYEAVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbYEAVfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbYEAVfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:35:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:23372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765837AbYEAVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Sx9nucVNKu38EDQ7byDcIP0gF67golhnQmiOPaJmlwAdh9llMzzOQW804ZHZqOGckaITcpHpC5P/F1GATmiIjKDCxOWddacNR125uee9gg1iuLlgBjszVizNCyMtrg/xF5m4WF2MnPCW1/GiFmgu8kr/lvSAZtH/h/R9tJ6HZ34=
Message-ID: <481A3781.8080100@gmail.com>
Date: Thu, 01 May 2008 23:34:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com> <20080501142305.77433e50.akpm@linux-foundation.org>
In-Reply-To: <20080501142305.77433e50.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2008 11:23 PM, Andrew Morton wrote:
> On Thu,  1 May 2008 17:56:02 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> megaraid_sas suspend and resume are inappropriatelly placed in
>> __devinit section.
> 
> That's a box-killer, isn't it?

I think so -- the non-CONFIG_HOTPLUG ones.
