Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbYG2SNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbYG2SNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYG2SNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:13:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:21193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYG2SNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xOqUyakHQIMJNYAXJxyWoIUUcatgXyL+rNL5x3KPwaWzWz147QKEupD/7IrO+bipZm
         oJADgJBwmZyUlfGPYJfK5ZxDk5+foSSBIRnarHJ4s77dvUE0r47T3UjrxAUgtSM7EWCv
         3zvV/x62ac3mKUBksiYempei6wlPk4G/8slrU=
Message-ID: <86802c440807291113u59ba996dg340c8feba1039f3a@mail.gmail.com>
Date: Tue, 29 Jul 2008 11:13:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Comments on UV tlb flushing
Cc: "Cliff Wickman" <cpw@sgi.com>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       steiner@sgi.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <488F2C9B.9070306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488E644B.10801@goop.org>
	 <200807291412.18495.nickpiggin@yahoo.com.au>
	 <20080729133204.GA13138@sgi.com> <488F2C9B.9070306@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 7:43 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Cliff Wickman wrote:
>>
>> I think that the Linux distributions are not going to build a special
>> UV kernel, are they?  So every distro would have to be prompted to turn on
>> CONFIG_X86_UV, or else their kernel is not going to boot on UV.
>>
>
> Distros will generally turn on everything.  You could have it on by default
> if the kernel is built for CONFIG_X86_GENERICARCH which enables support for
> other big numa configurations.  I think distros generally build with that
> enabled anyway.

config X86_GENERICARCH
       bool "Generic architecture"
        depends on X86_32
       help
          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
          subarchitectures.  It is intended for a generic binary kernel.
          if you select them all, kernel will probe it one by one. and will
          fallback to default.

YH
