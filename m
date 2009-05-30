Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbZE3LrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbZE3LrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZE3LrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:47:17 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43002 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbZE3LrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qVuGCizPYoB6a3Q1Laz4hlSYMJt16HmR5KvqffpWr4v/lszfeDS6TX51OQANBo9MNJ
         wrzoHN7jWYS1qtF98AHlwCrp9khbSlguMgQKXJZjqZ1tZEk93uhG4yea1xaUVwmHTYKZ
         Ma3kTcU0htY0C1U7MKTOPuTi5CXrP4uJdkdt8=
MIME-Version: 1.0
In-Reply-To: <4A211A2E.7090301@f2s.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	 <1243279681-4233-6-git-send-email-philipp.zabel@gmail.com>
	 <4A211A2E.7090301@f2s.com>
Date: Sat, 30 May 2009 13:47:16 +0200
Message-ID: <74d0deb30905300447u7b73c5b8r3a3406fa0ea3cff9@mail.gmail.com>
Subject: Re: [PATCH 5/5] mmc: tmio_mmc: move probe function into __init 
	section
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: ian@mnementh.co.uk
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 1:36 PM, Ian molton <spyro@f2s.com> wrote:
> Philipp Zabel wrote:
>>
>> As MFD cells are not hotpluggable, this should be safe to do.
>
> NAK, as per others comments.

Ok, dropped. I use mmc as rootfs right now, so I couldn't test that
(unbinding wreaks havoc either way).

regards
Philipp
