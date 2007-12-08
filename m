Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXLHVEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXLHVEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLHVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:04:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:35076 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXLHVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wbNkSoPa69G9izJGxEhe9VYZmZdP1wRN3eaBtK3oLTGr5AzGbgRbImpHzsoZJQvDlvrw+HbzvJE096LEM1O6C/bq1zIJiS1La3cjLnJEUrfLNCk6idNBHMf9aM/fs25BG8JqqsICC8dtXwA2y/ebcQQqL09VWOfwDp05PXy2hbg=
Message-ID: <82e4877d0712081304r19721b43w78b294ea8d470405@mail.gmail.com>
Date: Sat, 8 Dec 2007 16:04:33 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071208125144.734e9f81@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <20071208154755.GA5255@elte.hu>
	 <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
	 <20071208191330.GA21186@elte.hu>
	 <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
	 <20071208194211.GA579@elte.hu>
	 <82e4877d0712081208u335c968csd1d3e9259cdd2920@mail.gmail.com>
	 <20071208201137.GA13451@elte.hu>
	 <82e4877d0712081246x4d788c36i908916185611fa94@mail.gmail.com>
	 <20071208125144.734e9f81@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 3:51 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> what chipset is this?
> (I wonder if there's one where we shouldn't be force-enabling the hpet)

It's an Intel Mac Mini - Intel 945GM chipset.
I believe OSX requires HPET and so there shouldn't be a need to force
enable it on this chipset?

Also I don't have problems under Centos 5.1 kernel (2.6.18-53.1.4.el5)
and hpet is enabled there.

Parag
