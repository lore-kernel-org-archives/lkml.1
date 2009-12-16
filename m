Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbZLPG0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbZLPG0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761610AbZLPG0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:26:34 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:63018 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761602AbZLPG0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NRaWoqrrUguIhqHo17+xhtKN3mvnr6hzrOYP/jwPVtgsf/QagI2iPnIBNyx9sSSiGO
         z/+Sy9m6wNwwx0bjyIx7KBMe6w/sU+rADleRjiECLqjaewRuxpRCst4Z6CeyTWnXTE31
         rKiswlSDAx2KAKhvk0Uupah8buzE4yb/KwDuI=
MIME-Version: 1.0
In-Reply-To: <51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
References: <200912130807.44905.tvrtko@ursulin.net>
	 <4B26E4C7.8040100@gmail.com> <4B26E973.6080305@kernel.org>
	 <200912150955.03974.bjorn.helgaas@hp.com>
	 <51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
Date: Tue, 15 Dec 2009 22:26:32 -0800
X-Google-Sender-Auth: 5a25cd8af9c7bd6d
Message-ID: <86802c440912152226n26cde7f1mfa42273e9592dcbf@mail.gmail.com>
Subject: Re: Are these MTRR settings correct?
From: Yinghai Lu <yinghai@kernel.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:50 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
This was solved by using MMCONFIG
> for extended config space access only, so that when we move the BAR
> temporarily during sizing, we're not trying to access the MMCONFIG
> region it overlaps (since BAR sizing requires only base access).

how about IOV bar 0x184 and 190 ?

YH
