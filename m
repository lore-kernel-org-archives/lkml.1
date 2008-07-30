Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYG3X7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYG3X7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYG3X7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:59:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:2168 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYG3X7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=MZxJY6mjkFn3suxXmlA1c+IyGIrs+D9EWG4tp2w5ldf+9giknaDzUta2cktYuLcajS
         W3y0lJuyu7h+pokDPLWoygAsYI+xcAyR2031pXX9cy7VuYZAXDmNv1QEMPYoCjlJZ5KV
         FPAyxY9C3rvYmQI/lZlyV1TT60dKQSp6Sl28E=
Message-ID: <7c86c4470807301659t232a8dabw5272988d164898e@mail.gmail.com>
Date: Wed, 30 Jul 2008 16:59:34 -0700
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 00/19] perfmon2 minimal v3: introduction
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
	 <20080729014730.76b879a4.sfr@canb.auug.org.au>
	 <7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen


On Mon, Jul 28, 2008 at 11:20 PM, stephane eranian
<eranian@googlemail.com> wrote:
>>        quite a few of the macros (especially for the dummy (non
>> CONFIG_PERFMON) versions of functions) should be "static inline"
>> functions unless they absolutely must be macros.  Andrew Morton said it
>> best - "write in C not C preprocessor".
>>
Do you also have a problem with the debug printk statements using macros?
