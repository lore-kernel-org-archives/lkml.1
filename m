Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZCIXL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZCIXL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZCIXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:11:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:38420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZCIXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iBozJUpQbCkap3cqmZ7zFDZ8myIGQbDgZjMlDIPLYFoCOcg6lqnzJhazsi9WMhwGBZ
         awB5WATQ8d9H7CmvmyFXuau94NfBiy8CFgc5QtEuU1azhKLwe3sERqv95yP6912v7Ut2
         aDSaVwssWCEQSgX2KWELHM5+IoQIpj7KqxD04=
Message-ID: <49B5A212.1040300@gmail.com>
Date: Tue, 10 Mar 2009 00:11:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steve Rottinger <steve@www.rottinger.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Direct transfer between SCSI and PCI
References: <36600.12.35.250.145.1236605376.squirrel@www.rottinger.net>
In-Reply-To: <36600.12.35.250.145.1236605376.squirrel@www.rottinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.3.2009 14:29, Steve Rottinger wrote:
>As part
> of my project, I need to be able to directly transfer data from a large
> buffer that resides on
> a custom PCI communications device to a SCSI disk without going through
> the CPU's main
> memory.  Initially, it seemed like opening up the raw SCSI device in
> O_DIRECT mode would
> be the perfect solution.  However, through some experimentation, and
> reading some posts from
> a few years back, it appears that O_DIRECT only works on buffer's that
> reside in processor's
> main memory.   Does anyone have any suggestions as to how to get this to
> work?

How would you want your scsi device to get the data? I suppose they are 
stored somewhere on the PCI device memory connected to its local bus or 
alike. At best it can be visible as a PCI bar but I doubt it is. As you 
described it here, there is no way, how would the SCSI device see the data.

Or do you want to move the data from the PCI device via DMA implemented 
in it directly to the SCSI device? How would you do this? I guess SCSI 
devices do standard S/G DMA so that they read data from host memory by 
themselves.

Maybe if you elaborate on what exactly do you mean by the idea?
