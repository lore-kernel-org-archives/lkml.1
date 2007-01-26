Return-Path: <linux-kernel-owner+w=401wt.eu-S1030645AbXAZDZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030645AbXAZDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 22:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXAZDZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 22:25:58 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:3215 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030645AbXAZDZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 22:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CMQwFTmbqZ3U2rQ8YbFWczNroFfthA22p2HFUqkbkiA835NK6ePwKGmaJsgL8OpHzJ9rOI6zd41qedXmUc24i4VqR2l3hGyvHYKXTvZeTllISaopoFqaZAdwgwwOMmpAJOBZ6N0NXcHRCDAePLN/gYAxFJ/4sJrLnnt89S7SvHU=
Message-ID: <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
Date: Fri, 26 Jan 2007 11:25:56 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Stephen Evanchik" <evanchsa@gmail.com>
Subject: Re: SATA ahci Bug in 2.6.19.x
Cc: "Stefan Priebe - FH" <studium@profihost.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B46FA0.2060901@profihost.com>
	 <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the log:
2.6.18.3:
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
2.6.20-rc5:
"ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21"

Sounds like acpi interrupt configure problem. Please try acpi=off first.
