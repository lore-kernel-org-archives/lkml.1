Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYL2Mwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYL2Mwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYL2Mwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:52:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:29827 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYL2Mwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:52:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=bzEdrd39tS7zPAYOPtkuj/MLdaXKFFk0jnh22VydcVvvvy9sfEjbNDN6XxPDO3Tt0Y
         v7Bq6Ki1EmGuOSpHG71mS171APMwfYQUjJroXhNh38SP6sR9OlahkmMJtzIq1SJtIW3o
         AbBkOwJrgXDlsj7uMHyiVpDdZf3wECSYmbNTw=
Message-ID: <43d009740812290452l7a90de01nea3dad14cba58d85@mail.gmail.com>
Date: Mon, 29 Dec 2008 19:52:30 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: > I even didn't have a backtrace.
Cc: "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <4958C2CE.7060206@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.49EGxNgCILq/XfuGCazHZV8OJlg@ifi.uio.no>
	 <4958C2CE.7060206@yahoo.com>
X-Google-Sender-Auth: 80bb108fcee6b4d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/29 Sitsofe Wheeler <sitsofe@yahoo.com>:
> Igor Podlesny wrote:
>>
>>        BTW, I wonder -- can the kernel store crash related information (if
>> any) in RAM, at certain addresses, so it can survive warm reboot and
>> get displayed "in dmesg" on the next boot?
>
> Perhaps you are thinking of kdump - http://lwn.net/Articles/108595/ ?

	Similar, but no exactly. I just thought that unlikely BIOS erases
memory content during "fast checks", so kernel diagnostic could be
left at certain addresses, probably duplicated for safety, and newly
booted kernel could check if there were something left for it in RAM.
That's simpler than kdump/kexec, the question is only whether memory
is really left intact during BIOS work, at least partly.

-- 
End of message. Next message?
