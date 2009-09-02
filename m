Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZIBOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZIBOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZIBOmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:42:20 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:41672 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZIBOmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SRznxYQAGezpdP3pCueQkqQ+2pF62yYHMZEcnfhaZbI2dDqtZNHOQvje7uiVk0JF6U
         YufAmvkibI4BlGkDGO19eI8NjJcz+zEUAMstXeiJJbAG3jOzgKIt5CRglTlyJF5I1fCN
         /b1+Wun9LC8U2umSO5AFR9g5Zy8lVVOrUkdpc=
MIME-Version: 1.0
In-Reply-To: <20090902111927.GA4590@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com>
	 <20090902111927.GA4590@chram.org>
Date: Wed, 2 Sep 2009 08:42:20 -0600
Message-ID: <51f3faa70909020742g19007084j19a0ed071aaeffdf@mail.gmail.com>
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
From: Robert Hancock <hancockrwd@gmail.com>
To: Raphael Manfredi <Raphael_Manfredi@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 5:19 AM, Raphael
Manfredi<Raphael_Manfredi@pobox.com> wrote:
> Quoting Robert Hancock:
>> It's most likely a bug in the IDE code somewhere, but realistically the
>> most effective course of action would likely be to switch from the old IDE
>> drivers and use libata instead. The IDE code doesn't receive that much
>> testing these days, and it's really hard to debug (as you've seen, the
>> debugging output is rather atrocious).
>
> I gave it a shot anyway.  Converting to PATA was surprisingly straighforward.
>
> Anyway, I now get the following when running SMART long tests on /dev/sda:
>
>  ata1: lost interrupt (Status 0x50)
>
> And the machine hangs...  So I'm back to square one.
> How do I prevent lockups on the system when running SMART long tests?

Can you post what particular command you're running to run the SMART
test, and also the full dmesg output from bootup? Also CCing
linux-ide.
