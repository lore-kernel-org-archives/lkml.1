Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYISWdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYISWdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYISWc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:32:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:14533 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYISWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oPUU/+gSIbKEF9VaXa4ljAr6s1Yy/f8utGXFrQE1gsMW1aHpgtPX1FE4IQLc1+p7au
         7nYbBnOkBgUvlZKyz+a8GUc0rAZpG68uvec9jn1VKEM+C/GZgu5DUZtFNgKMot8pLM3W
         DIsmmEoXJXTFIZDynVKZ0DAZoXUd+5eaZcqng=
Message-ID: <70318cbf0809191532n6ebaa122v7d98815c8a65850b@mail.gmail.com>
Date: Fri, 19 Sep 2008 15:32:56 -0700
From: "Chris Li" <lkml@chrisli.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
	 <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
X-Google-Sender-Auth: 62715949c93c8301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 2:57 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> 0x1a.2
> 0x1d.1
> 0x1f.2
> 0x1f.5
>
> are sharing pin 0x19...
>
> but early dump can not find 0x1a.2, 0x1f.2, 0x1f.5

But later kernel does able to find those devices. Do you mean
there is a bug in the early PCI scanning?

Chris
