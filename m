Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbYKQNr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbYKQNr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKQNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:47:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:46883 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYKQNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mg3iLSqE1xV7+WM5CsdEO3Vm7UBDqAGd/mULoVWjF6gg5N7GwkgSlg7ApLZTiniBk2
         Jh+lGp+2jqjEXJ09FX7WJNQGYSXo9v2K5mVznB3JDGqgaLJTsojwexgBiucJ2HGj5EIT
         FwWN45LrwchVq/qyImOoB2kZc/6HdWxkGUrhk=
Message-ID: <ab4346860811170547j6f21ba2ducd451e761e165a5d@mail.gmail.com>
Date: Mon, 17 Nov 2008 15:47:16 +0200
From: "Victoria Muntean" <vikimun@gmail.com>
To: "J.R. Mauro" <jrm8005@gmail.com>,
       "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: Re: size of swapped-out part of the process
In-Reply-To: <3aaafc130811170533j4c7e0008vd76c42da0cbb9f36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
	 <3aaafc130811170533j4c7e0008vd76c42da0cbb9f36@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 3:33 PM, J.R. Mauro <jrm8005@gmail.com> wrote:
> On Mon, Nov 17, 2008 at 7:53 AM, Victoria Muntean <vikimun@gmail.com> wrote:
>> How can I calculate size of swapped-out part of the process from
>> /proc/PID/*, even if approximately ?
>> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
>> swap-in-use==0.
>> Hence (VmSize - VmRSS) is far from being swapped-out part of the
>> process. What is ?
>
> Doesn't top's SWAP field give you this?

No. SWAP is global. I need per-process. Per-process participation in swap.
