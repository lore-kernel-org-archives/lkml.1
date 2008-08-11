Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbYHKGz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbYHKGz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 02:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYHKGzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 02:55:16 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:39942 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYHKGzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 02:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vWI8XU5hFfCXL38kDB22QKx//ZdtLFHVClkjFaGNv9yEMImotT9vJDLBkU5X9QEpw2
         IRfnMSDkvpENp48HR2+bADwakVqiFDExFOaJmm9gkyS/tg7/S2LlkzeEhrYSxCK1oKlh
         wbEBhhOcngSr/fLklSlFGtMRjaqJF7WgZiXCg=
Message-ID: <ac94cb270808102355o1413f46ehcddb82ae69458c0d@mail.gmail.com>
Date: Mon, 11 Aug 2008 14:55:13 +0800
From: "Wang Yi" <leonidwang@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Segmentation fault details?
In-Reply-To: <ac94cb270808102337i5febf70fkb6d1f27f71cafb34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac94cb270808102334m1cc2c3a1n45202072d309927c@mail.gmail.com>
	 <ac94cb270808102337i5febf70fkb6d1f27f71cafb34@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

 I'd like to know some details about segmentation fault.
 What I mean is when a program accesses invalid memory area, it will
get a SIGSEGV signal from kernel, and a message "Segmentation fault".

 I also find that dmesg can show we something like this:
 ProgramName[Pid]: segfault at xxxx eip xxxx esp xxxx error x
 It is useful and provides the first-step information for further
debug/analysis.

 My question is how dmesg gets the information, and if there are any
"decent" way to get this and maybe more information(An "indecent" way
I came to is grep dmesg)
so that I can perform some basic auto analysis.

 Thank you.

Leo
