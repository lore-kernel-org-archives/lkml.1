Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZDWBD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZDWBD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZDWBDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:03:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:22513 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZDWBDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n6q2SQgOA5zzffIt/nIVKjFOyf5rzGIKHYQWCsj2TFfLrbeTAavd4lxcJklJaRkHXs
         delXIRNN4rkWDsjHfvXzR0ydVeyDBlA772crGklKeIz8xqqSmdvbNM+JMhA1uBjHoxPd
         K/gnMvKn/2+3QmrotnXU1qdOfJzEXFEQMP+VI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904222009340.19256@localhost.localdomain>
References: <alpine.LFD.2.00.0904222009340.19256@localhost.localdomain>
Date: Thu, 23 Apr 2009 11:03:45 +1000
X-Google-Sender-Auth: 97c2eac5e980799a
Message-ID: <9e6f3dfd0904221803k3377c149paa6a52bb80001874@mail.gmail.com>
Subject: Re: bad references to CONFIG variables from Makefiles
From: John Williams <jwilliams@itee.uq.edu.au>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 10:11 AM, Robert P. J. Day
<rpjday@crashcourse.ca> wrote:
>
>  a much shorter list of references to non-existent CONFIG variables
> from Makefiles only, short enough to just include inline:

> ===== XILINX_MICROBLAZE0_USE_PCMP =====
> ./arch/microblaze/Makefile:CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP) += -mxl-pattern-compare

We've got a patch queued to fix this one.

Thanks,

John
