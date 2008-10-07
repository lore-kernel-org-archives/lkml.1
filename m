Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYJGRJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYJGRJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYJGRJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:09:22 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53945 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYJGRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:09:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t1/3yaiT9yXKoclVbisgy+27s9MdxiEPadTnrqS+McikH5q8csmJNmwrbcrEhIEqli
         08mhH3tw9Iq4dzCVMLL/yo452KoT9Y41AHD72PnSTTmSTgLi80kgShOliA5dJI4zF/Lz
         87rul8d48fU8vE5rz9sYkXj4k7O1kWSULbvbU=
Message-ID: <3fedcc3b0810071009v68e5811ev11e9d512c58d371f@mail.gmail.com>
Date: Tue, 7 Oct 2008 14:09:18 -0300
From: "Thiago Lacerda" <thiagotbl@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Questions about mmap
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48EB8912.7070407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com>
	 <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>
	 <48E8C8AB.3010308@s5r6.in-berlin.de>
	 <3fedcc3b0810070638u60681b6do8a7e94c4919f4a40@mail.gmail.com>
	 <3fedcc3b0810070640p52852433v8ecf631a9b3dcd8f@mail.gmail.com>
	 <48EB8912.7070407@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you people.

When I try to dereference those pointers in user space I get a segfault :(

On Tue, Oct 7, 2008 at 1:06 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Thiago Lacerda wrote:
>> I'm trying to do like this:
>>
>> //Code of the char device
>> unsigned int **test;
>> static int device_mmap(struct file *filp, struct vm_area_struct *vma) {
> [...]
>> could you tell me what am I doing wrong?
>
> I can't; I never implemented a mmap file operation myself.
> --
> Stefan Richter
> -=====-==--- =-=- --===
> http://arcgraph.de/sr/
>



-- 
Thiago de Barros Lacerda
Computer Science Undergraduate Student - CIn/UFPE - 2004.2
Researcher/Software Developer - GPRT - Networking and
Telecommunications Research Group
