Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZHLE6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZHLE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZHLE6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:58:33 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:53123 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZHLE6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lnybYt8X/goZnP/YrazYrcQya+YaVn9giNKVPKR0qwZnaTkcxHkgcPVle5Qee6qmNh
         mdf3K+SiOrPUKpONIeCK+IzmGBa7BOJ8kMicN5bcXHWJd7BTYfJfUqBPYcbrTvzeFiDM
         ysagTy/36p5FmBSQFBYZC2y6zhzf7KyWnB2gM=
MIME-Version: 1.0
In-Reply-To: <20090811090554.79a1b1ac@bike.lwn.net>
References: <f74c922b0908110731ifcf162ai8770f07d7ca537d3@mail.gmail.com>
	 <20090811090554.79a1b1ac@bike.lwn.net>
Date: Wed, 12 Aug 2009 10:28:33 +0530
Message-ID: <f74c922b0908112158t78039addh826704ceda5d3199@mail.gmail.com>
Subject: Re: How to get the address of the page structure from the given 
	virtual address?
From: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Thanks for your response.

I'am writing a kernel socket which calls the tcp_sendpage (modified to
take array of pages) to send the data out
of the kernel socket. I'am allocating 32K of data by calling
alloc_pages and want to send this 32K of data. I modified the
tcp_sendpages to take an array of page structures.

Original version takes pointer to single page structure as an argument.

I will use the above calls to get the address of the page structure
and let you know.

Thanks
Vinai.
