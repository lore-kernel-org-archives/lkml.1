Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbXFPHRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbXFPHRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXFPHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:17:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:19147 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXFPHRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l6dL5GAsfEYeNd7qsVKNKEVp5UEVx8KeIt9IN4A5fFmoJN7mRJQhFjFOzcsXr8+FwvJPYFCt2hEX+/yToqnT8vAbTFbhnfoT3lwKzUuAHlaMNtliPAhANSMDLXIwcl8OLw+Uh0KhJeKqQchCb5/FGYyQt4ErMCp63QsvPlcGFos=
Message-ID: <4354d3270706160017t59e72882jd99a87a16288fe3f@mail.gmail.com>
Date: Sat, 16 Jun 2007 10:17:09 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CFS-v16: top shows incorrect CPU% for multi-threaded application
In-Reply-To: <4354d3270706131235x6c879f7emc1869700af108b27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4354d3270706131235x6c879f7emc1869700af108b27@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Török Edvin <edwintorok@gmail.com> wrote:
> Hi,
>
> When I run a multithreaded application, consisting of a "main thread"
> that is mostly idle, and
> 3 "worker threads" (using as much CPU as they can get), 'top' and 'ps'
> show that
> the application uses 0% CPU.
> If I turn off thread details in top, and ps it correctly shows the CPU
> usage of each thread.
>
> This happens only on 2.6.22-rc4-cfs-v16, on 2.6.21-1 everything is ok
> (top shows sum-of-all-threads-CPU-usage, i.e. ~98,99%).

This has been fixed in cfs-v17.

Thanks,
Edwin
