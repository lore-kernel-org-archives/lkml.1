Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZABFTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZABFTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 00:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZABFTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 00:19:33 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:50097 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZABFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 00:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ILyL08/m45n6Runs22ANSln2SdhAKsY6UCesllu/5cBzNplZVj35L5Xb7xmzYsep+6
         oLM4XhpqCLs/ozwbJQl5oNrFNxY96IpNSJSen3JIuM3uxqtmdj7clc6aEU3dzDmQ1otm
         g1RQwrh3QLLIj6DbndYgGKN8HV06b0nuOAzRQ=
Message-ID: <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
Date: Fri, 2 Jan 2009 00:19:29 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Ingo Brueckl" <ib@wupperonline.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <495d2974@wupperonline.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d2974@wupperonline.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 3:37 PM, Ingo Brueckl <ib@wupperonline.de> wrote:
> Is there any reason why CONFIG_PROCESSOR_SELECT is limited to EMBEDDED only?
>
> In my desktop pc is one specific cpu only, so I do not need support for the
> other processors. Unfortunately, I have no chance to disable the other ones.
>
> As it is already configurable, why not giving this option to everyone?

EMBEDDED is just a switch to enable configuration options related to
removing 'core' features of the kernel to save space. Think of it as a
safety to avoid accidentally turning off something important. Feel
free to switch on EMBEDDED if you want to use CONFIG_PROCESSOR_SELECT
- just enabling EMBEDDED doesn't do anything by itself.
