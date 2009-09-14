Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZINOe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZINOe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZINOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:34:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:7685 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZINOex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K41uaBmxN/Oqid9VdKIhLc53r1HiUUEE06Ll3G6Ws75HDgzukBnbeYjvjqMYFuikPs
         rt/WkFUTDGT3ycyQEhBK4woSwPhiV51zvchRlxuse6Ov19ZG8BWS4ohe1NBn777e9FNz
         Jl3Z5t2taT4e0O73SQmp+yGYGBlRaR0RZDeRA=
MIME-Version: 1.0
In-Reply-To: <1252936556.28368.215.camel@desktop>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
Date: Mon, 14 Sep 2009 17:34:55 +0300
Message-ID: <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 4:55 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Sun, 2009-09-13 at 22:38 +0300, Felipe Contreras wrote:
>> drivers/acpi/acpica/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
>> arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>
> Could you run this through checkpatch also, it looks like you have a few
> style issues..

I did... the style issues are already there, my patch is not
introducing them. Do you want me to send a separate patch to fix the
existing style issues?

-- 
Felipe Contreras
