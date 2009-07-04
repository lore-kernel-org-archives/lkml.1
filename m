Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZGDSAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZGDSAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZGDSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 14:00:22 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:62746 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZGDSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 14:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b6Zz0cQG1vM44TcgOqUC9BUpf9XyDTKxbfR8RvY2V1yh/O1xuS5Ut/hnquBlKLvgVi
         Oclj+XPtmsdjzY+y4MQZ8Ak8iPuzIp/eJD7JztuzW7yLgKduCh2QhSHuULrJ4MZc0RMF
         ERvelLwS10zDwTCUXopNNRmbNKhgHdc4/ibLw=
Message-ID: <4A4F98FE.4080903@gmail.com>
Date: Sat, 04 Jul 2009 12:01:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: value of returning positive error code from module_init()?
References: <alpine.LFD.2.00.0907041236440.3907@localhost>
In-Reply-To: <alpine.LFD.2.00.0907041236440.3907@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2009 10:38 AM, Robert P. J. Day wrote:
>    whoops, i forgot to ask this as well.  accidentally, i returned a
> positive value from a module_init() routine, which loaded the module
> and generated in /var/log/messages:
>
> ...
> Jul  4 12:34:43 localhost kernel: hi module being loaded.
> Jul  4 12:34:43 localhost kernel: sys_init_module: 'hi'->init
> suspiciously returned 42, it should follow 0/-E convention
> Jul  4 12:34:43 localhost kernel: sys_init_module: loading module
> anyway...
> Jul  4 12:34:43 localhost kernel: Pid: 3881, comm: insmod Tainted: G
> M       2.6.29.5-191.fc11.x86_64 #1
> Jul  4 12:34:43 localhost kernel: Call Trace:
> Jul  4 12:34:43 localhost kernel: [<ffffffff8106f33b>]
> sys_init_module+0x13e/0x1cd
> Jul  4 12:34:43 localhost kernel: [<ffffffff8101133a>]
> system_call_fastpath+0x16
> ...
>
>    i'd never seen that before, i guess because i never returned a
> positive error code.  is there a tradition for returning positive
> values?  for what purpose?  thanks.

My guess would be no, hence the warning you're not supposed to do it..
