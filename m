Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbXFBBIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbXFBBIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbXFBBIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:08:11 -0400
Received: from gw.goop.org ([64.81.55.164]:36926 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXFBBIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:08:10 -0400
Message-ID: <4660C2F6.6070005@goop.org>
Date: Fri, 01 Jun 2007 18:08:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com> <466093E3.4010701@goop.org> <46609636.4050208@zytor.com> <4660BBDF.1040007@goop.org> <4660BCF8.7000208@zytor.com> <4660C0CD.5060606@goop.org> <4660C194.4010003@zytor.com>
In-Reply-To: <4660C194.4010003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> It would have to, because of the way code32_start is defined to work.
> We don't get control again after its use as a hook.
>   

Who uses that hook?  The impression I get is that the execution
environment for jumping to that pointer is not very well defined at present.

    J
