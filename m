Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYI3WuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYI3WuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYI3WuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:50:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:10542 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbYI3Wt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:49:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mSPNO0kXwnqgAGUnu3Se+WGo5+HFj1eAMb9wBvf4XfFtgklxnom0rnUJxOecpksuUl
         kPIa6XFwP++0AKUSPTWDR4mQsETWg712Y8EekDEpz/g7/h6aFvZyrlOb5jBNpqtJCn1h
         MCZyZY+tnskF424XXnWmZ9ivbMEVBLk5lWbhU=
Message-ID: <f7848160809301549n5e8fb0fcr93ed10ba409b938e@mail.gmail.com>
Date: Tue, 30 Sep 2008 18:49:58 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86, Fix broken LDT access in VMI
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>
In-Reply-To: <20080930191356.GA28057@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222797732.7330.35.camel@bodhitayantram.eng.vmware.com>
	 <20080930191356.GA28057@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 3:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> -     vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
>> +     vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);

For a few seconds I thought it was diff going mad diff'ing exactly
similar lines.

This one could actually use some capitalization to reduce the
possibility of similar problems in future - rename to write_IDT_entry
and write_LDT_entry perhaps?

Parag
